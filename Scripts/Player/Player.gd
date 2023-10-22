extends CharacterBody3D

#region -- Player and state
@export_group("Player Parameters")
@export var walk_speed: float = 5.0
@export var sprint_speed: float = 9.0
@export var lerp_speed: float = 10.0
var current_speed: float = walk_speed
var movement_direction := Vector2.ZERO
var is_moving: bool = false

@export_group("State Parameters")
@export var sprint_fov: float = 80.0
var initial_fov: float
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
#endregion

#region -- Nodes
@export_group("Node Dependencies")
@export var spring_arm: SpringArm3D
@export var camera: Camera3D
@export var animated_sprite: AnimatedSprite3D
#endregion

#region -- Strings
    # Input
var input_forward: String = "up"
var input_backward: String = "down"
var input_left: String = "left"
var input_right: String = "right"
var input_sprint: String = "sprint"

    # Animation
var animation_walk_horizontal: String = "walk_horizontal"
var animation_walk_forward: String = "walk_forward"
var animation_walk_backward: String = "walk_backward"
#endregion

func _ready() -> void:
    spring_arm.add_excluded_object(self)
    initial_fov = camera.fov

func _process(delta: float) -> void:
    spring_arm.position = position

func _physics_process(delta: float) -> void:
    apply_gravity(delta)
    get_movement_state(delta)
    handle_animation()
    
    var input_direction: Vector2 = Input.get_vector(input_left, input_right, input_forward, input_backward)
    input_direction = input_direction.rotated(-spring_arm.rotation.y)
    movement_direction = lerp(movement_direction, input_direction, lerp_speed * delta)
    move(movement_direction, delta)
    
    move_and_slide()

func apply_gravity(delta: float) -> void:
    if not is_on_floor(): velocity.y -= gravity * delta

func get_movement_state(delta: float) -> void:
    is_moving = Vector2(velocity.x, velocity.z).length() > 0.05
    
    if Input.is_action_pressed(input_sprint) and is_moving:
        current_speed = sprint_speed
        camera.fov = lerp(camera.fov, sprint_fov, lerp_speed * delta)
    else:
        current_speed = walk_speed
        camera.fov = lerp(camera.fov, initial_fov, lerp_speed * delta)

func handle_animation() -> void:
    animated_sprite.speed_scale = 1.0 if current_speed == walk_speed else 2.0
    
    if roundf(velocity.x) != 0.0:
        animated_sprite.play(animation_walk_horizontal)
        animated_sprite.flip_h = roundf(velocity.x) > 0.0
    elif roundf(velocity.z) > 0.0:
        animated_sprite.play(animation_walk_forward)
    elif roundf(velocity.z) < 0.0:
        animated_sprite.play(animation_walk_backward)
    else:
        animated_sprite.stop()

func move(move_direction: Vector2, delta: float) -> void:
    velocity.x = move_direction.x * current_speed
    velocity.z = move_direction.y * current_speed
