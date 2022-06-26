extends Control

var scene_path_to_load
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	var button = get_node("Container/VBoxContainer/RestartButton")
	button.connect("pressed",self,"_on_Button_pressed",[button.scene_to_load])
func _on_Button_pressed(scene_to_load):
	scene_path_to_load = scene_to_load
	get_tree().change_scene(scene_path_to_load)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
func _on_FadeIn_fade_finished() -> void:
	get_tree().change_scene(scene_path_to_load)
