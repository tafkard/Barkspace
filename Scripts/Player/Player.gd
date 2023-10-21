extends CharacterBody3D

@export_group("Player Parameters")
@export var walk_speed: float = 5.0
@export var sprint_speed: float = 9.0
@export var lerp_speed: float = 10.0
var current_speed: float = walk_speed
var movement_direction := Vector2.ZERO

@export_group("State Parameters")
@export var sprint_fov: float = 80.0
var initial_fov: float

@export_group("Node Dependencies")
@export var collision_shape: CollisionShape3D
@export var spring_arm: SpringArm3D
@export var camera: Camera3D
@export var animated_sprite: AnimatedSprite3D

# Input strings
var forward_input: String = "forward"
var backward_input: String = "backward"
var left_input: String = "left"
var right_input: String = "right"
var sprint_input: String = "sprint"

# Animation strings
var horizontal_walk_animation: String = "walk_horizontal"
var forward_walk_animation: String = "walk_forward"
var backward_walk_animation: String = "walk_backward"

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
    # Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
    spring_arm.add_excluded_object(self)
    initial_fov = camera.fov

func _process(delta: float) -> void:
    spring_arm.position = position

func _physics_process(delta: float) -> void:
    apply_gravity(delta)
    get_movement_state(delta)
    handle_animation()
    
    var input_direction: Vector2 = Input.get_vector(left_input, right_input, forward_input, backward_input)
    movement_direction = lerp(movement_direction, input_direction, lerp_speed * delta)
    move(movement_direction, delta)
    
    move_and_slide()

func apply_gravity(delta: float) -> void:
    if not is_on_floor(): velocity.y -= gravity * delta

func get_movement_state(delta: float) -> void:
    if Input.is_action_pressed(sprint_input):
        current_speed = sprint_speed
        camera.fov = lerp(camera.fov, sprint_fov, lerp_speed * delta)
    else:
        current_speed = walk_speed
        camera.fov = lerp(camera.fov, initial_fov, lerp_speed * delta)

func move(move_direction: Vector2, delta: float) -> void:
    velocity.x = move_direction.x * current_speed
    velocity.z = move_direction.y * current_speed

func handle_animation() -> void:
    animated_sprite.speed_scale = 1.0 if current_speed == walk_speed else 2.0
    
    if roundf(velocity.x) != 0.0:
        animated_sprite.play(horizontal_walk_animation)
        animated_sprite.flip_h = roundf(velocity.x) > 0.0
    elif roundf(velocity.z) > 0.0:
        animated_sprite.play(forward_walk_animation)
    elif roundf(velocity.z) < 0.0:
        animated_sprite.play(backward_walk_animation)
    else:
        animated_sprite.stop()
