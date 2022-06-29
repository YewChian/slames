extends KinematicBody2D

var velocity  = Vector2(0,0)
var speed = 300
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var collision_info = move_and_collide(velocity.normalized()*delta*speed)
	if collision_info != null:
		var body = collision_info.collider
		if body != $CollisionShape2D:
			body.hit()
			get_parent().remove_child(self)

func hit():
	pass
