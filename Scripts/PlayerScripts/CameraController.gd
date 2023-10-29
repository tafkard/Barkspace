extends SpringArm3D

## Enable for debugging only
@export var allow_mouse_movement: bool = false

#region -- Mouse and camera
@export_group("Mouse Parameters")
@export var mouse_sensitivity: float = 0.01

@export_group("Camera Parameters")
@export var x_min_rotation: float = -70.0
@export var x_max_rotation: float = 70.0
var initial_spring_length: float
var initial_rotation: Vector3
#endregion

#region -- Strings
var input_zoom_in: String = "zoom_in"
var input_zoom_out: String = "zoom_out"
var input_toggle_cursor: String = "toggle_cursor"
var input_toggle_camera: String = "toggle_camera"
#endregion

func _ready() -> void:
    if allow_mouse_movement: Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
    initial_spring_length = spring_length
    initial_rotation = rotation

func _input(event: InputEvent) -> void:
    if event is InputEventMouseMotion and allow_mouse_movement:
        rotation.x -= event.relative.y * mouse_sensitivity
        rotation.x = clampf(rotation.x, deg_to_rad(x_min_rotation), deg_to_rad(x_max_rotation))
        rotation.y -= event.relative.x * mouse_sensitivity
        rotation.y = wrapf(rotation.y, 0.0, deg_to_rad(360.0))

func _process(delta: float) -> void:
    # Toggle mouse movement + reset length and rotation
    if Input.is_action_just_pressed(input_toggle_camera):
        allow_mouse_movement = !allow_mouse_movement
        spring_length = initial_spring_length
        rotation = initial_rotation
    
    if not allow_mouse_movement: return
    
    if Input.is_action_just_released(input_zoom_in): spring_length -= 0.5
    if Input.is_action_just_released(input_zoom_out): spring_length += 0.5
    
    if Input.is_action_just_pressed(input_toggle_cursor):
        if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
            Input.mouse_mode = Input.MOUSE_MODE_VISIBLE 
        else: Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
