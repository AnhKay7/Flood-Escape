extends CharacterBody2D

#BASE_MOVE
const SPEED = 120.0
const ACCELERATION = 1500.0
const FRICTION = 1800
var direction = 0
var facing_diraction = 1

#DASH
var unlockedDash = true
var isDashing = false
var canDash = false
var dashTimer = 0.0
const DASH_DURATION = 0.2
const DASH_SPEED = 400
const DASH_GRAVITY_MULT = 0.25

#GRAVITY
const MAX_FALL_SPEED = 600
const MAX_FALL_SPEED_FOR_DASH = 80

#BASE_JUMP
const JUMP_VELOCITY = -300.0
const MAX_COYOTE_TIMER = 0.12
var coyote_timer = 0.0
const MAX_JUMP_BUFFER_TIMER = 0.12
var jump_buffer_timer = 0.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	Handle_Dash(delta)
	if isDashing == false:
		Handle_Gravity(delta)
		Handle_jump(delta)
		Handle_Movement(delta)
	Handle_Animation()
	move_and_slide() ### MUST HAVE

func Handle_jump(delta : float) -> void:
	if is_on_floor():
		coyote_timer = MAX_COYOTE_TIMER
	else:
		coyote_timer -= delta
		
	jump_buffer_timer -= delta
	
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = MAX_JUMP_BUFFER_TIMER
		
	if coyote_timer > 0 and jump_buffer_timer > 0:
		velocity.y = JUMP_VELOCITY
		coyote_timer = 0
		jump_buffer_timer = 0
		
	if Input.is_action_just_released("jump"):
		if velocity.y < 0:
			velocity.y = 0

func Handle_Gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	velocity.y = min(velocity.y, MAX_FALL_SPEED)

func Handle_Movement(delta: float) -> void:
	direction = Input.get_axis("left", "right")
	
	if direction != 0:
		facing_diraction = direction
	
	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	

func Handle_Animation() -> void:
	
	if isDashing:
		animated_sprite_2d.play("dash")
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
	if is_on_floor() and isDashing == false:
		canDash = true
	
	if Input.is_action_just_pressed("dash") and canDash and unlockedDash:
		isDashing = true
		canDash = false
		dashTimer = DASH_DURATION
	
	if isDashing:
		dashTimer -= delta
		velocity.x = DASH_SPEED * facing_diraction
		
		velocity.y = max(velocity.y, 0) ### TRANH DASH CHEO LEN
		velocity.y += get_gravity().y * delta * DASH_GRAVITY_MULT
		velocity.y = min(velocity.y, MAX_FALL_SPEED_FOR_DASH) 
		
	if dashTimer <= 0: 
		isDashing = false
