extends Area3D  

@export_file var scene_to_load: String

#region -- Nodes
@export_group("Node Dependencies")
@export var dialogue_box: Sprite3D
@export var animation_player: AnimationPlayer
#endregion

#region -- Strings
    # Input
var input_interact: String = "interact"

    # Animation
var animation_hover: String = "hover"
#endregion

var is_within_area: bool = false

func _on_body_entered(body: Node3D) -> void:
    if not body is CharacterBody3D: return
    
    is_within_area = true
    dialogue_box.visible = true
    animation_player.play(animation_hover)

func _on_body_exited(body: Node3D) -> void:
    if not body is CharacterBody3D: return
    
    is_within_area = false
    dialogue_box.visible = false
    animation_player.stop()

func _process(delta: float) -> void:
    if Input.is_action_just_pressed(input_interact) and is_within_area:
        print("Entered door")
        get_tree().change_scene_to_file(scene_to_load)
