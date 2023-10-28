extends RichTextLabel

@export var hover_magnitude: float = 4.0
@export var transition_duration: float = 0.4

func _ready() -> void:
    HoverTween.play_vector2(self, position, hover_magnitude, transition_duration)
