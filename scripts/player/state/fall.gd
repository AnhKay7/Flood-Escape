extends PlayerState

func enter(previous_state_path: String, data = {}) -> void:
	player.animated_sprite_2d.play("fall")
	
func physics_update(delta: float) -> void:
	
	player.direction = Input.get_axis("left", "right")
	
	player.velocity.x = move_toward(player.velocity.x, player.direction * player.SPEED, player.ACCELERATION * delta)
	player.velocity.y += player.get_gravity().y * delta
	player.velocity.y = min(player.velocity.y, player.MAX_FALL_SPEED)
	
	if player.direction != 0:
		player.facing_diraction = player.direction
	
	if player.direction > 0:
		player.animated_sprite_2d.flip_h = false
	elif player.direction < 0:
		player.animated_sprite_2d.flip_h = true
	
	if player.is_on_floor():
		if player.direction == 0:
			finished.emit(IDLE)
		else:
			finished.emit(RUN)
		return
	
	if player.coyote_timer > 0 and player.jump_buffer_timer > 0:
		finished.emit(JUMP)
		return
	
	if player.dash_buffer_timer > 0 and player.can_dash and player.unlocked_dash and player.dash_cd_timer <= 0:
		finished.emit(DASH)
		return
	
	if not player.is_on_floor() and player.is_on_wall():
		finished.emit(WALL_CLIMB)
		return 
	pass
