extends CharacterBody2D

#BASE_MOVE
const SPEED = 150.0
const ACCELERATION = 1500.0
const FRICTION = 1800
var direction = 0
var facing_diraction = 1

#DASH
var unlockedDash = true
var isDashing = false
var canDash = false
var dashTimer = 0.0
var dashCdTimer = 0.0
var dash_buffer_timer = 0.0
const DASH_DURATION = 0.2
const DASH_SPEED = 400
const DASH_GRAVITY_MULT = 0.25
const MAX_DASH_CD = 0.5
const MAX_DASH_BUFFER_TIMER = 0.12

#GRAVITY
const MAX_FALL_SPEED = 600
const MAX_FALL_SPEED_FOR_DASH = 80

#BASE_JUMP
const JUMP_VELOCITY = -360.0
const MAX_COYOTE_TIMER = 0.12
var coyote_timer = 0.0
const MAX_JUMP_BUFFER_TIMER = 0.12
var jump_buffer_timer = 0.0

#WALL_CLIMB
var isWallSliding = false
var wallDirection = 0
var wall_jump_timer = 0
const MAX_WALL_JUMP_TIMER = 0.13
const MAX_WALL_SLIDE_SPEED = 60.0
const WALL_JUMP_VELOCITY = -350
const WALL_JUMP_PUSHBACK_FORCE = 400

#ANIMATION
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	Handle_Buffer(delta)
	Handle_Dash(delta)
	Handle_Wall_Climb(delta)
	if isDashing == false and isWallSliding == false:
		Handle_Gravity(delta)
		Handle_jump()
		Handle_Movement(delta)
	Handle_Animation()
	move_and_slide() ### MUST HAVE

func Handle_Buffer(delta: float) -> void:
	
	#buffer
	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta
	if dash_buffer_timer > 0:
		dash_buffer_timer -= delta
	
	#skill cool-down
	if dashCdTimer > 0: 
		dashCdTimer -= delta 
	
	#duration
	if wall_jump_timer > 0:
		wall_jump_timer -= delta
	if coyote_timer > 0:
		coyote_timer -= delta
	
	#get buffer
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = MAX_JUMP_BUFFER_TIMER
	if Input.is_action_just_pressed("dash"):
		dash_buffer_timer = MAX_DASH_BUFFER_TIMER

func Handle_jump() -> void:
	if is_on_floor():
		coyote_timer = MAX_COYOTE_TIMER
		
	if coyote_timer > 0 and jump_buffer_timer > 0:
		velocity.y = JUMP_VELOCITY
		coyote_timer = 0
		jump_buffer_timer = 0
		
	if Input.is_action_just_released("jump"):
		if velocity.y < 0:
			velocity.y /= 4

func Handle_Gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	velocity.y = min(velocity.y, MAX_FALL_SPEED)

func Handle_Movement(delta: float) -> void:
	direction = Input.get_axis("left", "right")
	
	if direction != 0:
		facing_diraction = direction
		
	if wall_jump_timer > 0:
		direction = -wallDirection
		velocity.x = move_toward(velocity.x, 0, FRICTION * 0.3 * delta)
	else:
		if direction:
			velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	

func Handle_Animation() -> void:
	
	if isDashing:
		animated_sprite_2d.play("dash")
		return
		
	if isWallSliding:
		if animated_sprite_2d.animation != "wall_climb":
			animated_sprite_2d.play("wall_climb")
		if wallDirection == -1:
			animated_sprite_2d.flip_h = true
		elif wallDirection == 1:
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

func Handle_Dash(delta: float) -> void:
	
	if (is_on_floor() or is_on_wall()) and isDashing == false:
		canDash = true
	
	if dash_buffer_timer > 0 and canDash and unlockedDash and dashCdTimer <= 0:
		isDashing = true
		canDash = false
		dashTimer = DASH_DURATION
		dashCdTimer = MAX_DASH_CD
		velocity.y = max(velocity.y, 0) ### TRANH DASH CHEO LEN
		
	if isDashing:
		dashTimer -= delta
		velocity.x = DASH_SPEED * facing_diraction
		
		velocity.y += get_gravity().y * delta * DASH_GRAVITY_MULT
		velocity.y = min(velocity.y, MAX_FALL_SPEED_FOR_DASH) 
		
	if dashTimer <= 0: 
		isDashing = false
		#Phanh lai sau khi DASH
		velocity.x = clamp(velocity.x, -SPEED, SPEED) ### <=> velocity.x = max(-SPEED, min(velocity.x, SPEED))

func Handle_Wall_Climb(delta: float) -> void:
	
	if is_on_wall() and is_on_floor() == false:
		if isDashing or velocity.y >= 0:
			isWallSliding = true
		if isDashing:
			isDashing = false
			dashTimer = 0
	else:
		isWallSliding = false
		
	if isWallSliding: 
		#Truot Slide
		velocity.y = min(velocity.y + get_gravity().y * 0.2 * delta, MAX_WALL_SLIDE_SPEED)
		
		#Tranh roi khoi tuong
		wallDirection = -get_wall_normal().x
		velocity.x = wallDirection * 10.0
		
		#Jump
		if jump_buffer_timer > 0:
			velocity.y = WALL_JUMP_VELOCITY
			velocity.x = -wallDirection * WALL_JUMP_PUSHBACK_FORCE
			
			isWallSliding = false
			jump_buffer_timer = 0
			coyote_timer = 0
			wall_jump_timer = MAX_WALL_JUMP_TIMER
			
		
		direction = Input.get_axis("left", "right") ###CAP NHAT HUONG
		if direction != 0 and direction != wallDirection:
			isWallSliding = false
			
	
