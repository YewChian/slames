extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
onready var player1 = get_node("Player1")
onready var player2 = get_node("Player2")
#onready var lightning_f = get_node("f_LightningWand")	
#onready var fire_f = get_node("f_FireWand")
#onready var ice_f = get_node("f_IceWand")
onready var lightning_f_path = preload("res://Slames/FloorWands/f_LightningWand.tscn")
onready var fire_f_path = preload("res://Slames/FloorWands/f_FireWand.tscn")
onready var ice_f_path = preload("res://Slames/FloorWands/f_IceWand.tscn")
var ice_f
var fire_f
var lightning_f
var choosewand:int
var options = [0,1,2]
# Called when the node enters the scene tree for the first time.
func _ready():
	init_weapons()
	player2.connect("target_hit",self,"hit1")
	player1.connect("target_hit",self,"hit2")

func hit1(smth):
	if smth == player1:
		player2.return_origin()
		player1.hit()

func hit2(smth):
	if smth == player2:
		player1.return_origin()
		player2.hit()

func init_weapons():
	randomize()
	choosewand = randi()%options.size()
	choosewand = 2
	if choosewand == 0:
		fire_f = fire_f_path.instance()
		$Wands.add_child(fire_f)

	elif choosewand == 1:
		ice_f = ice_f_path.instance()
		$Wands.add_child(ice_f)

	elif choosewand == 2:
		lightning_f = lightning_f_path.instance()
		$Wands.add_child(lightning_f)

func screen_shake():
	var camera = get_node("Camera2D")
	camera.transform.origin.x -= 6
	camera.transform.origin.y -= 4	
	yield(get_tree().create_timer(0.05), "timeout")	
	camera.transform.origin.x += 12
	camera.transform.origin.y += 1	
	yield(get_tree().create_timer(0.05), "timeout")		
	camera.transform.origin.x -= 6
	camera.transform.origin.y += 3	

func _on_Player1_death() -> void:
	screen_shake()
	init_weapons()


func _on_Player2_death() -> void:
	screen_shake()
	init_weapons()
