class_name HoverTween extends Node3D

static func play_vector3(target_object, start_position: Vector3, hover_magnitude: float, transition_duration: float) -> void:
    var tween: Tween = target_object.create_tween()
    var end_position: Vector3 = start_position + Vector3.UP * hover_magnitude
    
    tween.set_loops()
    tween.set_trans(Tween.TRANS_SPRING)
    # Always tween FROM start_position to avoid problems when player moves away during transition
    tween.tween_property(target_object, "position", end_position, transition_duration).from(start_position)
    tween.tween_property(target_object, "position", start_position, transition_duration)

static func play_vector2(target_object, start_position: Vector2, hover_magnitude: float, transition_duration: float) -> void:
    var tween: Tween = target_object.create_tween()
    var end_position: Vector2 = start_position + Vector2.UP * hover_magnitude
    
    tween.set_loops()
    tween.set_trans(Tween.TRANS_SPRING)
    tween.tween_property(target_object, "position", end_position, transition_duration).from(start_position)
    tween.tween_property(target_object, "position", start_position, transition_duration)
