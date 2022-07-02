extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
signal reload1
# Called when the node enters the scene tree for the first time.
func _ready():
	Lives.lives = 3
	
func _physics_process(_delta):
	if Lives.lives == 2:
		$Life3.hide()
	if Lives.lives == 1:
		$Life2.hide()
	if Lives.lives == 0:
		emit_signal("reload1")
		get_tree().change_scene("res://Slames/Scene/Screen/EndScreen.tscn")
		
