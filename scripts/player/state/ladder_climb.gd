extends PlayerState


func enter(previous_state_path: String, data = {}) -> void:
	
	player.velocity = Vector2.ZERO 
	player.animated_sprite_2d.play("ladder_climb") 

func physics_update(delta: float) -> void:

	player.velocity.y = player.climb_direction * player.CLIMB_SPEED
	player.velocity.x = player.direction * player.LADDER_CLIMB_MOVE_SPEED 
	
	if player.climb_direction == 0:
		player.animated_sprite_2d.pause() 
	else:
		player.animated_sprite_2d.play()  

	if Input.is_action_just_pressed("jump"):
		player.ladder_hop_timer = player.MAX_LADDER_HOP_TIMMER
		finished.emit(JUMP)
		return
		
	if player.is_on_floor() and player.climb_direction > 0:
		finished.emit(IDLE)
		return
		
	if not player.is_near_ladder:
		if player.velocity.y < 0: 
			player.velocity.y = player.JUMP_VELOCITY * 0.6 
			finished.emit(FALL) 
		else:
			finished.emit(FALL) 
		return
