extends PlayerState

func enter(previous_state_path: String, data = {}) -> void:
	player.animated_sprite_2d.play("fall")
	
func physics_update(delta: float) -> void:
	
	if player.facing_diraction > 0:
		player.animated_sprite_2d.flip_h = false
	elif player.facing_diraction < 0:
		player.animated_sprite_2d.flip_h = true
	
	if player.wall_jump_timer > 0:
		player.direction = -player.wall_direction
		player.velocity.x = move_toward(player.velocity.x, 0, player.AIR_FRICTION * 0.5 * delta)
	else:
		player.direction = Input.get_axis("left", "right")
		if player.direction:
			player.velocity.x = move_toward(player.velocity.x, player.direction * player.SPEED, player.ACCELERATION * delta)
		else:
			player.velocity.x = move_toward(player.velocity.x, 0, player.AIR_FRICTION * delta)
		
	if abs(player.velocity.y) < 100.0:
		player.velocity.y += (player.GRAVITY * 0.5) * delta
	else:
		player.velocity.y += player.GRAVITY * delta
		
	player.velocity.y = min(player.velocity.y, player.MAX_FALL_SPEED)
	
	if player.is_near_ladder and Input.is_action_pressed("up"):
		finished.emit(LADDERCLIMB)
		return
	
	if player.is_on_floor():
		if player.direction == 0:
			finished.emit(IDLE)
		else:
			finished.emit(RUN)
		return
	
	if player.jump_buffer_timer > 0 and player.is_on_wall_timer > 0:
		finished.emit(JUMP, {"is_wall_jump": true})
		return
	
	if player.coyote_timer > 0 and player.jump_buffer_timer > 0:
		finished.emit(JUMP)
		return
	
	if player.dash_buffer_timer > 0 and player.can_dash and player.unlocked_dash and player.dash_cd_timer <= 0:
		finished.emit(DASH)
		return
	
	if player.is_on_wall() and player.direction == player.wall_direction:
		finished.emit(WALL_CLIMB)
		return 
	pass
