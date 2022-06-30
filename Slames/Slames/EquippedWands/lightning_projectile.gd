extends KinematicBody2D

var velocity  = Vector2(0,0)
var speed = 300
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
signal hit_target
onready var timer = get_node("Timer")

func _ready() -> void:
	$AnimationPlayer.play("move")
	timer.start()
	
func _physics_process(delta):
	if stepify(timer.time_left,0.01) <= 0.1:
		$CollisionShape2D.disabled = false
	if timer.is_stopped():
		get_parent().remove_child(self)
	var collision_info = move_and_collide(velocity)
	if collision_info != null:
		var body = collision_info.collider
		if body != $CollisionShape2D:
			var reaction = body.hit()
			if reaction != "same":
				emit_signal("hit_target")
				get_parent().remove_child(self)
				

func hit():
	return "same"
