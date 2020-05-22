extends Control

onready var bloom = get_node("ColorRect")

func _ready():
	bloom.set_size(Vector2(get_viewport().size.x, get_viewport().size.y))

func _on_StartGame_pressed():
	get_tree().change_scene("res://Scenes/Level.tscn")

func _on_QuitGame_pressed():
	get_tree().quit()

func _on_Bloom_pressed():
	if bloom.visible == true:
		bloom.visible = false
		Settings.bloom = false
	else:
		bloom.visible = true
		Settings.bloom = true
