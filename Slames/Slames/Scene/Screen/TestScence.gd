extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
onready var player1 = get_node("Player1")
onready var player2 = get_node("Player2")
onready var lightning_f = get_node("f_LightningWand")	
onready var fire_f = get_node("f_FireWand")
onready var ice_f = get_node("f_IceWand")
var choosewand:int
var options = [0,1,2]
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	choosewand = randi()%options.size()
	if not lightning_f:
		add_child(lightning_f)
	if not fire_f:
		add_child(fire_f)
	if not ice_f:
		add_child(ice_f)
	if choosewand == 0:
		remove_child(lightning_f)
		remove_child(ice_f)
	elif choosewand == 1:
		remove_child(fire_f)
		remove_child(ice_f)
	elif choosewand == 2:
		remove_child(lightning_f)
		remove_child(fire_f)
	player2.connect("target_hit",self,"hit1")
	player1.connect("target_hit",self,"hit2")

func hit1(smth):
	player2.return_origin()
	player1.hit() 

func hit2(smth):
	player1.return_origin()
	player2.hit()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
func _on_f_FireWand_picked() -> void:
	remove_child(fire_f)

func _on_f_IceWand_ice_picked() -> void:
	remove_child(ice_f)

func _on_f_LightningWand_lightning_picked() -> void:
	remove_child	(lightning_f)
