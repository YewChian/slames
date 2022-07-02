extends KinematicBody2D

var velocity  = Vector2(0,0)
var speed = 300
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
signal hit_target

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("move")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var collision_info = move_and_collide(velocity.normalized()*delta*speed)
	if collision_info != null:
		var body = collision_info.collider
		if body != $CollisionShape2D:
			var reaction = body.hit()
			if reaction == "boundary":
				get_parent().remove_child(self)
			elif reaction != "same":
				emit_signal("hit_target")
				get_parent().remove_child(self)

func hit():
	return "same"

func pickup(smth):
	return "projectile"
