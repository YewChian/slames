extends Node2D
signal bluewins
signal reload2
func _ready():
	RedSlimeLives.lives = 3
	
func _physics_process(_delta):
	if RedSlimeLives.lives == 2:
		$Sprite3.hide()
	if RedSlimeLives.lives == 1:
		$Sprite2.hide()
	if RedSlimeLives.lives == 0:
		emit_signal("bluewins")
		emit_signal("reload2")
		get_tree().change_scene("res://Slames/Scene/Screen/EndScreenBlueWins.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
