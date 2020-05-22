extends Node2D

signal pause
signal gameover

onready var pertti = get_node("Pertti")
onready var windowsScene = load("Scenes/Windows.tscn")
onready var healthLabel = get_node("HUD/Health")
onready var audioHurt = get_node("AudioStreamPlayer")
onready var scoreLabel = get_node("HUD/Score")
onready var scoreTimer = get_node("Score")
onready var restartButton = get_node("HUD/GameOver/Restart")
onready var quitButton = get_node("HUD/GameOver/Quit")
onready var gameOverLabel = get_node("HUD/GameOver/Game Over")
onready var audioBoom = get_node("AudioStreamPlayer2")
onready var bloom = get_node("HUD/ColorRect")

var gameover = false
var scoretimer
var spawntimer
var health = 3
var rng = RandomNumberGenerator.new()
var timer = 60
var spawnmin = 15
var spawnmax = 30
var score = 0

func _ready():
	bloom.set_size(Vector2(get_viewport().size.x, get_viewport().size.y))
	bloom.visible = Settings.bloom
	
	gameOverLabel.visible = false
	quitButton.visible = false
	restartButton.visible = false
	
	pertti.set_position(Vector2(get_viewport().size.x / 2, get_viewport().size.y - (get_viewport().size.y / 4)))
	get_viewport().connect("size_changed", self, "_on_viewport_size_changed")
	
	spawntimer = Timer.new()
	add_child(spawntimer)
	spawntimer.connect("timeout", self, "_on_spawntimer_timeout")
	spawntimer.set_wait_time(5.0)
	spawntimer.set_one_shot(false)
	spawntimer.start()
	
	scoreLabel.text = "Score: " + str(score)
	healthLabel.text = "Health: " + str(health)

func _physics_process(delta):
	
	rng.randomize()
	timer -= 1
	if timer <= 0 and !gameover:
		var windows = windowsScene.instance()
		add_child(windows)
		timer = rng.randi_range(spawnmin, spawnmax)
		
	if Input.is_action_pressed("pause"):
		emit_signal("pause")
		get_tree().paused = true

func _on_viewport_size_changed():
	bloom.set_size(Vector2(get_viewport().size.x, get_viewport().size.y))
	if !gameover:
		pertti.set_position(Vector2(pertti.position.x, get_viewport().size.y - (get_viewport().size.y / 4)))
		if pertti.position.x >= get_viewport().size.x:
			pertti.set_position(Vector2(get_viewport().size.x, pertti.position.y))

func _on_Pertti_collision():
	health -= 1
	print("Damage Taken")
	healthLabel.text = "Health :" + str(health)
	if health != 0:
		audioHurt.play()
	if health == 0:
		audioBoom.play()
		gameover = true
		print("Game Over")
		emit_signal("gameover")

func _on_spawntimer_timeout():
	print("Timer elapsed")
	if spawnmin > 5:
		spawnmin -= 2
	if spawnmax > 5:
		spawnmax -= 2

func _on_Pertti_done():
	restartButton.visible = true
	quitButton.visible = true
	gameOverLabel.visible = true
	
	gameOverLabel.set_position(Vector2((get_viewport().size.x - gameOverLabel.get_rect().size.x) / 2, 200 ))
	quitButton.set_position(Vector2((get_viewport().size.x - quitButton.get_rect().size.x) / 2, 350 ))
	restartButton.set_position(Vector2((get_viewport().size.x - restartButton.get_rect().size.x) / 2, 275 ))

func _on_Restart_pressed():
	get_tree().reload_current_scene()

func _on_Quit_pressed():
	get_tree().quit()

func _on_Score_timeout():
	if !gameover:
		score += 1
		scoreLabel.text = "Score: " + str(score)
