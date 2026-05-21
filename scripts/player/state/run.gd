extends PlayerState


func enter(previous_state_path : String, data = {}):
	player.animated_sprite_2d.play("run")
	
func physics_update(delta: float) -> void:
	
	player.direction = Input.get_axis("left", "right")
	player.velocity.x = move_toward(player.velocity.x, player.direction * player.SPEED, player.ACCELERATION * delta)
	player.velocity.y += player.GRAVITY * delta;
	
	if player.direction != 0:
		player.facing_diraction = player.direction
	
	if player.direction > 0:
		player.animated_sprite_2d.flip_h = false
	elif player.direction < 0:
		player.animated_sprite_2d.flip_h = true
	
	if not player.is_on_floor():
		finished.emit(FALL)
		return
	if player.jump_buffer_timer > 0.0:
		finished.emit(JUMP)
		return
	if player.dash_buffer_timer > 0.0 and player.can_dash and player.unlocked_dash and player.dash_cd_timer <= 0.0:
		finished.emit(DASH)
		return
	#tren dat + khong nhay + khong dash + velocity = 0 = idle
	if player.direction == 0.0:
		finished.emit(IDLE)
		return
	
	
