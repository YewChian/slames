extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
signal lightning_picked
var randloc = [
	Vector2(180,470),
	Vector2(640,78)
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	var rand_index:int = randi() % randloc.size()
	print(rand_index,randloc[rand_index])
	position = randloc[rand_index]
	$AnimationPlayer.play("LightningAnim")
	$Sprite/Area2D.connect("body_entered",self,"on_body_entered")

func on_body_entered(smth):
	var body_list = $Sprite/Area2D.get_overlapping_bodies()
	var bodi = body_list[0]
	#emit_signal("lightning_picked")
	bodi.pickup("lightning")

