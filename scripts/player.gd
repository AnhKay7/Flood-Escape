extends CharacterBody2D

const SPEED = 120.0
const JUMP_VELOCITY = -300.0
const max_coyote_timer = 0.12
var coyote_timer = 0.0
const max_jump_buffer_timer = 0.12
var jump_buffer_timer = 0.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	Handle_Garvity(delta)
	Handle_jump(delta)
	Handle_Movement()

func Handle_jump(delta : float) -> void:
	if is_on_floor():
		coyote_timer = max_coyote_timer
	else:
		coyote_timer -= delta
		
	jump_buffer_timer -= delta
	
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = max_jump_buffer_timer
		
	if coyote_timer > 0 and jump_buffer_timer > 0:
		velocity.y = JUMP_VELOCITY
		coyote_timer = 0
		jump_buffer_timer = 0
		
	if Input.is_action_just_released("jump"):
		if velocity.y < 0:
			velocity.y = 0

func Handle_Garvity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

func Handle_Movement() -> void:
	var direction := Input.get_axis("left", "right")
	
	Handle_Animation(direction)
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()

func Handle_Animation(direction: float) -> void:
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true
	
	if is_on_floor():
		if velocity.x == 0:
			animated_sprite_2d.play("idle")
		else:
			animated_sprite_2d.play("run")
	else:
		if velocity.y < 0:
			animated_sprite_2d.play("jump")
		else:
			animated_sprite_2d.play("fall")
