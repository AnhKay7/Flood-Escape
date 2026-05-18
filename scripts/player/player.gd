extends CharacterBody2D
class_name Player
#region BASE_MOVEMENT_VARIABLES
const SPEED = 150.0
const ACCELERATION = 1700.0
const FRICTION = 2000
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
const DASH_DURATION = 0.2
const DASH_SPEED = 400
const DASH_GRAVITY_MULT = 0.25
const MAX_DASH_CD = 0.5
const MAX_DASH_BUFFER_TIMER = 0.1
#endregion
#region GRAVITY_VARIABLES
const MAX_FALL_SPEED = 600
const MAX_FALL_SPEED_FOR_DASH = 80
#endregion
#region BASE_JUMP_VARIABLES
const JUMP_VELOCITY = -360.0
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
const WALL_JUMP_PUSHBACK_FORCE = 400
#endregion
#region ANIMATION_VARIABLES
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
#endregion

func _physics_process(delta: float) -> void:
	Handle_Buffer(delta)
	handle_dash(delta)
	handle_wall_climb(delta)
	if is_dashing == false and is_wall_sliding == false:
		apply_gravity(delta)
		handle_jump()
		handle_movement(delta)
	handle_animation()
	move_and_slide() ### MUST HAVE -> cap nhat hinh anh

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
		is_on_wall_timer = MAX_IS_ON_WALL_TIMER
#endregion
#region JUMP_ACTION
func handle_jump() -> void:
	if is_on_floor():
		coyote_timer = MAX_COYOTE_TIMER
	
	if coyote_timer > 0 and jump_buffer_timer > 0:
		execute_jump(JUMP_VELOCITY)
		if Input.is_action_pressed("jump") == false:
			cut_jump()
	
	if Input.is_action_just_released("jump"):
		cut_jump()

func execute_jump(cur_jump_velocity : float) -> void:
	velocity.y = cur_jump_velocity
	coyote_timer = 0
	jump_buffer_timer = 0
	is_on_wall_timer = 0

func cut_jump() -> void:
	if velocity.y < 0:
			velocity.y /= 2
#endregion
#region APPLY_GRAVITY and MOVE_ACTION

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	velocity.y = min(velocity.y, MAX_FALL_SPEED)

func handle_movement(delta: float) -> void:
	direction = Input.get_axis("left", "right")
	
	if direction != 0:
		facing_diraction = direction
		
	if wall_jump_timer > 0:
		direction = -wall_direction
		velocity.x = move_toward(velocity.x, 0, FRICTION * 0.5 * delta)
	else:
		if direction:
			velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
#endregion
#region ANIMATION
func handle_animation() -> void:
	
	if is_dashing:
		animated_sprite_2d.play("dash")
		return
		
	if is_wall_sliding:
		if animated_sprite_2d.animation != "wall_climb":
			animated_sprite_2d.play("wall_climb")
		if wall_direction == -1:
			animated_sprite_2d.flip_h = true
		elif wall_direction == 1:
			animated_sprite_2d.flip_h = false
		return
		
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true
	
	if is_on_floor():
		if direction == 0:
			animated_sprite_2d.play("idle")
		else:
			animated_sprite_2d.play("run")
	else:
		if velocity.y < 0:
			animated_sprite_2d.play("jump")
		else:
			animated_sprite_2d.play("fall")
#endregion
#region DASH_ACTION
func handle_dash(delta: float) -> void:
	
	if (is_on_floor() or is_on_wall()) and is_dashing == false:
		can_dash = true
	
	if dash_buffer_timer > 0 and can_dash and unlocked_dash and dash_cd_timer <= 0:
		start_dash()
	
	if is_dashing:
		execute_dash_physics(delta)
	
	if dash_timer <= 0: 
		end_dash()
func execute_dash_physics(delta : float) -> void:
	velocity.x = DASH_SPEED * facing_diraction
	velocity.y += get_gravity().y * delta * DASH_GRAVITY_MULT
	velocity.y = min(velocity.y, MAX_FALL_SPEED_FOR_DASH) 
func start_dash() -> void:
		is_dashing = true
		can_dash = false
		dash_timer = DASH_DURATION
		dash_cd_timer = MAX_DASH_CD
		velocity.y = max(velocity.y, 0) ### TRANH DASH CHEO LEN
func end_dash() -> void:
	dash_timer = 0
	is_dashing = false
	#Phanh lai sau khi DASH
	velocity.x = clamp(velocity.x, -SPEED, SPEED) ### <=> velocity.x = max(-SPEED, min(velocity.x, SPEED))	
#endregion
#region WALL_CLIMB_ACTION
func handle_wall_climb(delta: float) -> void:
	
	if is_on_wall():
		wall_direction = -get_wall_normal().x
		
	var close_to_wall = is_on_wall_timer > 0 and is_on_floor() == false
	
	if is_on_wall() and not is_on_floor():
		if is_dashing or velocity.y >= 0:
			is_wall_sliding = true
		if is_dashing:
			end_dash()
	else:
		is_wall_sliding = false
		
	if is_wall_sliding: 
		execute_wall_slide(delta)
	
	if jump_buffer_timer > 0 and close_to_wall:
		execute_wall_jump()

func execute_wall_slide(delta: float) -> void:
	#Truot Slide
	velocity.y = min(velocity.y + get_gravity().y * 0.2 * delta, MAX_WALL_SLIDE_SPEED)
	
	#Tranh roi khoi tuong
	velocity.x = wall_direction * 10.0
	
	direction = Input.get_axis("left", "right") ###CAP NHAT HUONG
	if direction != 0 and direction != wall_direction:
		is_wall_sliding = false

func execute_wall_jump() -> void:
	execute_jump(WALL_JUMP_VELOCITY)
	velocity.x = -wall_direction * WALL_JUMP_PUSHBACK_FORCE
	
	is_wall_sliding = false
	wall_jump_timer = MAX_WALL_JUMP_TIMER
#endregion
