extends Node

onready var quitButton = get_node("Quit")
onready var resumeButton = get_node("Resume")
onready var pauseLabel = get_node("Pause")

func _ready():
	pauseLabel.visible = false
	resumeButton.visible = false
	quitButton.visible = false

func _on_Level_pause():
	pauseLabel.visible = true
	resumeButton.visible = true
	quitButton.visible = true
	pauseLabel.set_position(Vector2((get_viewport().size.x - pauseLabel.get_rect().size.x) / 2, 200 ))
	quitButton.set_position(Vector2((get_viewport().size.x - quitButton.get_rect().size.x) / 2, 350 ))
	resumeButton.set_position(Vector2((get_viewport().size.x - resumeButton.get_rect().size.x) / 2, 275 ))


func _on_Resume_pressed():
	pauseLabel.visible = false
	resumeButton.visible = false
	quitButton.visible = false
	get_tree().paused = false


func _on_Quit_pressed():
	get_tree().quit()
