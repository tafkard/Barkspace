extends Node3D

@export_multiline var lines: Array[String]

@export var text_scroll_speed: float = 0.05

var current_dialogue: String = ""
var current_character: int = 0

func _ready() -> void:
    for character: String in lines[0]:
        current_dialogue += lines[0][current_character]
        current_character += 1
        print(current_dialogue)
        
        await get_tree().create_timer(text_scroll_speed).timeout
