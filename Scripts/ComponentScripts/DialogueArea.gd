class_name DialogueArea
extends Area3D

var is_within_area: bool = false

@export_group("Bounce Parameters")
@export var hover_magnitude: float = 0.5
@export var transition_duration: float = 0.5

@export_group("Node Dependencies")
@export var dialogue_box: Sprite3D
@export var dialogue_box_texture: Texture2D

var dialogue_box_position: Vector3

func _ready() -> void:
    dialogue_box.texture = dialogue_box_texture
    dialogue_box_position = dialogue_box.position

func _on_body_entered(body: Node3D) -> void:
    if not body is CharacterBody3D: return    
    
    is_within_area = true
    dialogue_box.visible = true
    HoverTween.play_vector3(dialogue_box, dialogue_box_position, hover_magnitude, transition_duration)

func _on_body_exited(body: Node3D) -> void:
    if not body is CharacterBody3D: return
    
    is_within_area = false
    dialogue_box.visible = false
