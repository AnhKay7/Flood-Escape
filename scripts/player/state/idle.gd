extends PlayerState

@onready var landing: AudioStreamPlayer = $"../../Audio/Landing"

func enter(previous_state_path: String, data = {}) -> void:
	#player.velocity.x = 0.0
	if (previous_state_path == FALL):
		print("ASDOJOA")
		landing.play()
	player.animated_sprite_2d.play("idle")

func physics_update(delta: float) -> void:
	if player.facing_diraction > 0:
		player.animated_sprite_2d.flip_h = false
	elif player.facing_diraction < 0:
		player.animated_sprite_2d.flip_h = true
	
	player.velocity.x = move_toward(player.velocity.x, 0, player.FRICTION * delta)
	player.velocity.y += player.GRAVITY * delta
	
	if not player.is_on_floor():
		finished.emit(FALL)
		return
	
	if player.is_near_ladder and Input.is_action_pressed("up"):
		finished.emit(LADDERCLIMB)
		return
	
	if player.jump_buffer_timer > 0:
		finished.emit(JUMP)
		return
	
	if player.dash_buffer_timer > 0 and player.can_dash and player.unlocked_dash and player.dash_cd_timer <= 0:
		finished.emit(DASH)
		return
	
	if player.is_on_floor() and player.direction:
		finished.emit(RUN)
		return
