extends Control

var scene_path_to_load
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
# Called when the node enters the scene tree for the first time.
onready var button = get_node("Container/VBoxContainer/RestartButton")

func _ready() -> void:
	for button in $Container/VBoxContainer/Buttons.get_children():
		button.connect("pressed",self,"_on_Button_pressed",[button.scene_to_load])
	
func _on_Button_pressed(scene_to_load):
	scene_path_to_load = scene_to_load
	get_tree().change_scene(scene_path_to_load)
	
func _on_FadeIn_fade_finished() -> void:
	get_tree().change_scene(scene_path_to_load)
