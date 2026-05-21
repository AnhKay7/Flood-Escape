class_name Player extends CharacterBody2D
#region BASE_MOVEMENT_VARIABLES
const SPEED = 150.0
const ACCELERATION = 1500.0
const FRICTION = 1700.0
var direction = 0
var facing_diraction = 1
#endregion
#region DASH_VARIABLES
var unlocked_dash = true
var is_dashing = false
var can_dash = false
var dash_timer = 0.0
var dash_cd_timer = 0.0
var dash_buffer_timer = 0.0
const DASH_DURATION = 0.18
const DASH_SPEED = 350
const DASH_GRAVITY_MULT = 0.25
const MAX_DASH_CD = 0.5
const MAX_DASH_BUFFER_TIMER = 0.1
#endregion
#region GRAVITY_VARIABLES
const GRAVITY = 600;
const MAX_FALL_SPEED = 600
const MAX_FALL_SPEED_FOR_DASH = 80
#endregion
#region BASE_JUMP_VARIABLES
const AIR_FRICTION = 1000
const JUMP_VELOCITY = -300.0
const MAX_COYOTE_TIMER = 0.12
var coyote_timer = 0.0
const MAX_JUMP_BUFFER_TIMER = 0.12
var jump_buffer_timer = 0.0
#endregion
#region WALL_CLIMB_VARIABLES
var is_wall_sliding = false
var wall_direction = 0
var wall_jump_timer = 0
var is_on_wall_timer = 0
const MAX_IS_ON_WALL_TIMER = 0.05
const MAX_WALL_JUMP_TIMER = 0.1
const MAX_WALL_SLIDE_SPEED = 60.0
const WALL_JUMP_VELOCITY = -350
const WALL_JUMP_PUSHBACK_FORCE = 200
#endregion
#region ANIMATION_VARIABLES
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
#endregion

@onready var state_machine = $StateMachine

func _physics_process(delta: float) -> void:
	Handle_Buffer(delta)
	
	state_machine._physics_process(delta)
	
	move_and_slide() ### MUST HAVE -> cap nhat hinh anh

func _unhandled_input(event: InputEvent) -> void:
	state_machine._unhandled_input(event)

func _process(delta: float) -> void:
	state_machine._process(delta)

#region TIMER_MANAGEMENT
func Handle_Buffer(delta: float) -> void:
	##buffer
	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta
	if dash_buffer_timer > 0:
		dash_buffer_timer -= delta
	if is_on_wall_timer > 0:
		is_on_wall_timer -= delta
	if coyote_timer > 0:
		coyote_timer -= delta
	##skill cool-down
	if dash_cd_timer > 0: 
		dash_cd_timer -= delta 
	##duration
	if wall_jump_timer > 0:
		wall_jump_timer -= delta
	if dash_timer > 0:
		dash_timer -= delta
	##get buffer
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = MAX_JUMP_BUFFER_TIMER
	if Input.is_action_just_pressed("dash"):
		dash_buffer_timer = MAX_DASH_BUFFER_TIMER
	if is_on_wall():
		can_dash = true
		wall_direction = -get_wall_normal().x
		is_on_wall_timer = MAX_IS_ON_WALL_TIMER
	if is_on_floor():
		coyote_timer = MAX_COYOTE_TIMER
		can_dash = true
#endregion
