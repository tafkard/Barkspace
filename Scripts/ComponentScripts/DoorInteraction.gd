extends Node3D

@export_file var scene_to_load: String
@export var dialogue_area: DialogueArea

var input_interact: String = "interact"

func _process(delta: float) -> void:
    if Input.is_action_just_pressed(input_interact) and dialogue_area.is_within_area:
        get_tree().change_scene_to_file(scene_to_load)
