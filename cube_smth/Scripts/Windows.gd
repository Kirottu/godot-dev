extends RigidBody2D

signal collision

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	self.set_position(Vector2(rng.randi_range(0, get_viewport().size.x), 0))

func _physics_process(delta):
	if self.position.y >= get_viewport().size.y:
		queue_free()
		print("Destroyed")
