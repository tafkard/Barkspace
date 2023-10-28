extends Control

@export_multiline var lines: Array[String]

#region -- Parameters
@export_group("Parameters")
@export var text_scroll_speed: float = 0.05
#endregion

#region -- Nodes
@export_group("Node Dependencies")
@export var dialogue_area: DialogueArea
@export var dialogue_box: Panel
@export var dialogue_text: RichTextLabel
@export var enter_icon: RichTextLabel
@export var scroll_sound: AudioStreamPlayer
#endregion

#region -- Strings
var input_interact: String = "interact"
#endregion

var current_line: int = 0
var is_text_scrolling: bool = false

func _process(delta: float) -> void:    
    if not dialogue_area.is_within_area:
        reset_dialogue()
        return
    
    if Input.is_action_just_pressed(input_interact) and dialogue_area.is_within_area:
        # Reset dialogue after all lines are iterated through
        if current_line == lines.size():
            reset_dialogue()
            return
        
        dialogue_area.visible = false
        dialogue_box.visible = true
        play_next_line()

func play_next_line() -> void:
    var displayed_text: String = ""
    enter_icon.visible = false
    is_text_scrolling = true
    
    for character: String in lines[current_line]:
        displayed_text += character
        dialogue_text.text = displayed_text
        scroll_sound.play()
        await get_tree().create_timer(text_scroll_speed).timeout
    
    current_line += 1
    enter_icon.visible = true
    is_text_scrolling = false

func reset_dialogue() -> void:
    current_line = 0
    dialogue_area.visible = true
    dialogue_box.visible = false
