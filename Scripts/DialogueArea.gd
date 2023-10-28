class_name DialogueArea
extends Area3D

@export var dialogue_box: Sprite3D
@export var dialogue_box_texture: Texture2D

var is_within_area: bool = false

func _ready() -> void:
    dialogue_box.texture = dialogue_box_texture

func _on_body_entered(body: Node3D) -> void:
    if not body is CharacterBody3D: return    
    
    is_within_area = true
    dialogue_box.visible = true
    bounce_tween(dialogue_box, 0.1, 0.6)

func _on_body_exited(body: Node3D) -> void:
    if not body is CharacterBody3D: return
    
    is_within_area = false
    dialogue_box.visible = false

func bounce_tween(dialogue: Sprite3D, bounce_magnitude: float, transition_duration: float) -> void:
    var tween: Tween = dialogue.create_tween()
    var start_position: Vector3 = dialogue.position
    var end_position: Vector3 = dialogue.position + (Vector3.UP * bounce_magnitude)
    tween.set_loops()
    tween.set_trans(Tween.TRANS_SPRING)
    tween.tween_property(dialogue, "position", end_position, transition_duration)
    tween.tween_property(dialogue, "position", start_position, transition_duration)
