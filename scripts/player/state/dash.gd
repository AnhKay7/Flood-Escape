extends PlayerState

func enter(previous_state_path: String, data = {}) -> void:
	player.velocity.y = max(player.velocity.y, 0) # tranh dash cheo len
	player.can_dash = false
	player.dash_timer = player.DASH_DURATION
	player.dash_cd_timer = player.MAX_DASH_CD
	player.animated_sprite_2d.play("dash")
	pass

func exit() -> void:
	player.dash_timer = 0
	player.velocity.x = clamp(player.velocity.x, -player.SPEED, player.SPEED)
	pass

func physics_update(delta: float) -> void:
	
	player.direction = Input.get_axis("left", "right")
	
	if player.direction != 0 and player.dash_timer <= 0:
		player.facing_diraction = player.direction
		
	player.velocity.x = player.DASH_SPEED * player.facing_diraction
	player.velocity.y += player.get_gravity().y * delta * player.DASH_GRAVITY_MULT
	player.velocity.y = min(player.velocity.y, player.MAX_FALL_SPEED_FOR_DASH) 
	
		
	if player.facing_diraction > 0:
		player.animated_sprite_2d.flip_h = false
	elif player.facing_diraction < 0:
		player.animated_sprite_2d.flip_h = true
		
	if player.dash_timer > 0 and player.is_on_wall():
		finished.emit(WALL_CLIMB)
		return
	
	if player.dash_timer <= 0:
		if player.is_on_floor():
			if player.direction == 0:
				finished.emit(IDLE)
			else:
				finished.emit(RUN)
		else:
			finished.emit(FALL)
	
	
	
