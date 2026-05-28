class_name BaseCharacter extends CharacterBody2D
#region BASE_MOVEMENT_VARIABLES
const SPEED = 135.0
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
const DASH_SPEED = 300
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
const AIR_FRICTION = 1000.0
const JUMP_VELOCITY = -350.0
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
const MAX_WALL_JUMP_TIMER = 0.08
const MAX_WALL_SLIDE_SPEED = 60.0
const WALL_JUMP_VELOCITY = -300
const WALL_JUMP_PUSHBACK_FORCE = 200
#endregion
#region ANIMATION_VARIABLES
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
#endregion
#region LADDER_CLIMB_VARIABLES
var is_near_ladder: bool = false
var ladder_hop_timer = 0.0
var climb_direction = 0
const MAX_LADDER_HOP_TIMMER = 0.2
const LADDER_CLIMB_MOVE_SPEED = 55
const CLIMB_SPEED = 70.0

#endregion
@onready var state_machine = $StateMachine
@export var world_tilemap: TileMapLayer

func _physics_process(delta: float) -> void:
	handle_buffer(delta)
	
	handle_input()
	
	state_machine._physics_process(delta)
	
	move_and_slide() ### MUST HAVE -> cap nhat hinh anh
	# Đặt đoạn này ngay SAU hàm move_and_slide() của Player
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider is RigidBody2D:
			var normal = collision.get_normal()
			
			if normal.y < -0.5:
				continue
				
			if abs(velocity.x) > 0.1:
				collider.linear_velocity.x = velocity.x * 0.8

func _unhandled_input(event: InputEvent) -> void:
	state_machine._unhandled_input(event)

func _process(delta: float) -> void:
	state_machine._process(delta)

#region TIMER_MANAGEMENT
func handle_buffer(delta: float) -> void:
	##buffer
	if ladder_hop_timer > 0:
		ladder_hop_timer -= delta
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
#endregion
func check_ladder() -> bool:
	if not world_tilemap:
		return false
		
	var map_pos = world_tilemap.local_to_map(global_position)
	
	var tile_data = world_tilemap.get_cell_tile_data(map_pos)
	
	if tile_data:
		return tile_data.get_custom_data("is_ladder")

	return false
func handle_input() -> void:
	
	climb_direction = Input.get_axis("up", "down")
	direction = Input.get_axis("left","right")
	if direction != 0 and dash_timer <= 0:
		facing_diraction = direction
	
	is_near_ladder = check_ladder()
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
