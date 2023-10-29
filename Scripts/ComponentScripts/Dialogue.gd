extends Control

@export_multiline var lines: Array[String]

#region -- Parameters
@export_group("Parameters")
@export var text_scroll_speed: float = 0.04
@export var transition_distance: float = 200.0
@export var transition_duration: float = 0.2
#endregion

#region -- Nodes
@export_group("Node Dependencies")
@export var dialogue_area: DialogueArea
@export var dialogue_box: Panel
@export var dialogue_text: RichTextLabel
@export var enter_icon: RichTextLabel
@export var scroll_sound: AudioStreamPlayer
#endregion

# Input strings
var input_interact: String = "interact"

var current_line: int = 0
var is_scrolling: bool = false
var interact_cooldown: float = 0.0

func _process(delta: float) -> void:
    # No inputs are registered until cooldown times out
    if interact_cooldown > 0.0:
        interact_cooldown -= delta
        return
    
    # Exit if player moves away during dialogue
    if (is_scrolling or current_line > 0) and not dialogue_area.is_within_area:
        toggle_dialogue_box(false)
        is_scrolling = false
        return
    
    if Input.is_action_just_pressed(input_interact) and dialogue_area.is_within_area:
        if is_scrolling:
            skip_scroll()
            return
        
        if current_line == lines.size(): # Exit once all lines are iterated through
            toggle_dialogue_box(false)
            return
        elif current_line == 0: # Enable when dialogue is starting
            toggle_dialogue_box(true)
        
        play_next_line()

func play_next_line() -> void:
    var displayed_text: String = ""
    enter_icon.visible = false
    is_scrolling = true
    
    for character: String in lines[current_line]:
        if not is_scrolling: return # Exit function if scroll is skipped
        
        displayed_text += character
        dialogue_text.text = displayed_text
        scroll_sound.play()
        await get_tree().create_timer(text_scroll_speed).timeout
    
    current_line += 1
    enter_icon.visible = true
    is_scrolling = false

func skip_scroll() -> void:
    dialogue_text.text = lines[current_line]
    current_line += 1
    enter_icon.visible = true
    is_scrolling = false

func toggle_dialogue_box(enable: bool = false) -> void:
    current_line = 0
    
    var tween: Tween = dialogue_box.create_tween().set_trans(Tween.TRANS_SPRING)
    
    if enable:
        dialogue_area.visible = false
        dialogue_box.visible = true
        tween.tween_property(dialogue_box, "position", dialogue_box.position + Vector2.UP * transition_distance, transition_duration)
    else:
        tween.tween_property(dialogue_box, "position", dialogue_box.position + Vector2.UP * -transition_distance, transition_duration)
        tween.tween_property(dialogue_box, "visible", false, 0.0) # Hide after tween has finished moving
        dialogue_area.visible = true
        interact_cooldown = 0.5
