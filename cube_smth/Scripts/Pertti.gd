extends KinematicBody2D

onready var animation = get_node("AnimationPlayer")
onready var blood = get_node("Blood")
onready var smoke = get_node("Explosion/Smoke")
onready var sparks = get_node("Explosion/Sparks")
onready var sprite = get_node("Sprite")

var gameover = false
var destruction = 0
var invinsibility = 90
var speed = 500
var movement = Vector2()

signal collision
signal done

func _ready():
	sprite.set_texture(load(Settings.pertti))
	
func _physics_process(delta):
	if invinsibility > 0:
		invinsibility -= 1
	
	if not self.position.x <= 0 and Input.is_action_pressed("ui_left") and !gameover:
		movement.x = -speed
	if not self.position.x >= get_viewport().size.x and Input.is_action_pressed("ui_right") and !gameover:
		movement.x = speed
	move_and_slide(movement)
	movement.x = 0

func _on_Area2D_body_entered(body):
	print(body.name)
	if "Windows" in body.name and invinsibility == 0:
		emit_signal("collision")
		print("Collision")
		animation.play("Invinsibility")
		blood.restart()
		invinsibility = 90

func _on_Level_gameover():
	gameover = true
	sparks.restart()
	smoke.restart()
	var timer = Timer.new()
	timer.set_wait_time(3)
	timer.set_one_shot(true)
	self.add_child(timer)
	timer.start()
	yield(timer, "timeout")
	timer.queue_free()
	emit_signal("done")
