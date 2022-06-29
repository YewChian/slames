extends TileMap


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

var body_list
# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D.connect("body_entered",self,"_on_body_enter")
	
func _on_body_enter(_body):
	body_list = $Area2D.get_overlapping_bodies()
	var bodi = body_list[0]
	

func on_area2d_body_entered(body) :
	body.area_entered(self)  

func hit():
	pass
