extends Sprite3D    

@export var animation_player: AnimationPlayer

var animation_hover: String = "hover"

func _on_interactable_area_body_entered(body: Node3D) -> void:
    if not body is CharacterBody3D: return
    visible = true
    animation_player.play(animation_hover)

func _on_interactable_area_body_exited(body: Node3D) -> void:
    if not body is CharacterBody3D: return
    visible = false
    animation_player.stop()
