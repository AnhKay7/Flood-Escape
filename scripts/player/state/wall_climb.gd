extends PlayerState

func enter(previous_state_path: String, data = {}) -> void:
	player.velocity.y = 0.0
	player.animated_sprite_2d.play("wall_climb")

func physics_update(delta: float) -> void:
	
	player.velocity.y = min(player.velocity.y + player.get_gravity().y * 0.1 * delta, player.MAX_WALL_SLIDE_SPEED)
	player.velocity.x = player.wall_direction * 10.0
	
	player.direction = Input.get_axis("left","right")
	
	
	if player.jump_buffer_timer > 0:
		finished.emit(JUMP)
		return
	
	if player.dash_buffer_timer > 0 and player.dash_cd_timer <= 0 and player.unlocked_dash and player.can_dash:
		finished.emit(DASH)
		return
	
	if player.is_on_floor():
		if player.direction != 0:
			finished.emit(RUN)
		else:
			finished.emit(IDLE)
		return
	
	if player.direction != player.wall_direction and player.direction != 0:
		finished.emit(FALL)
		return
	
	if not player.is_on_wall():
		finished.emit(FALL)
		return
	
	pass
