extends PlayerState

func execute_jump(cur_jump_velocity : float) -> void:
	player.velocity.y = cur_jump_velocity
	player.coyote_timer = 0
	player.jump_buffer_timer = 0
	player.is_on_wall_timer = 0
func cut_jump() -> void:
	if player.velocity.y < 0:
		player.velocity.y /= 2
func execute_wall_jump() -> void:
	execute_jump(player.WALL_JUMP_VELOCITY)
	player.velocity.x = -player.wall_direction * player.WALL_JUMP_PUSHBACK_FORCE
	
	player.wall_jump_timer = player.MAX_WALL_JUMP_TIMER
	
func enter(previous_state_path: String, data = {}) -> void:
	if data.get("is_wall_jump", false) == true or previous_state_path == WALL_CLIMB:
		execute_wall_jump()
	else:
		execute_jump(player.JUMP_VELOCITY)
	player.animated_sprite_2d.play("jump")

func physics_update(delta: float) -> void:
	
	if player.wall_jump_timer > 0:
		player.direction = -player.wall_direction
		player.velocity.x = move_toward(player.velocity.x, 0, player.AIR_FRICTION * delta)
	else:
		player.direction = Input.get_axis("left", "right")
		if player.direction:
			player.velocity.x = move_toward(player.velocity.x, player.direction * player.SPEED, player.ACCELERATION * delta)
		else:
			player.velocity.x = move_toward(player.velocity.x, 0, player.AIR_FRICTION * delta)
	
	player.velocity.y += player.get_gravity().y * delta
	player.velocity.y = min(player.velocity.y, player.MAX_FALL_SPEED)
	
	if Input.is_action_pressed("jump") == false: 
		cut_jump()
	
	if player.direction != 0:
		player.facing_diraction = player.direction
	
	if player.direction > 0:
		player.animated_sprite_2d.flip_h = false
	elif player.direction < 0:
		player.animated_sprite_2d.flip_h = true
	
	if player.velocity.y >= 0:
		finished.emit(FALL)
		return
		
	if player.dash_buffer_timer > 0 and player.can_dash and player.unlocked_dash and player.dash_cd_timer <= 0:
		finished.emit(DASH)
		return
		
	if player.is_on_floor():
		if player.direction == 0:
			finished.emit(IDLE)
		else:
			finished.emit(RUN)
		return
	
	
