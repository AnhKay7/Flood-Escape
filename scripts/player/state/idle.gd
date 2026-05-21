extends PlayerState

func enter(previous_state_path: String, data = {}) -> void:
	#player.velocity.x = 0.0
	player.animated_sprite_2d.play("idle")

func physics_update(delta: float) -> void:
	player.velocity.x = move_toward(player.velocity.x, 0, player.FRICTION * delta)
	player.velocity.y += player.GRAVITY * delta
	
	if not player.is_on_floor():
		finished.emit(FALL)
		return
	
	if player.jump_buffer_timer > 0:
		finished.emit(JUMP)
		return
	
	if player.dash_buffer_timer > 0 and player.can_dash and player.unlocked_dash and player.dash_cd_timer <= 0:
		finished.emit(DASH)
		return
	
	if player.is_on_floor() and Input.get_axis("left", "right"):
		finished.emit(RUN)
		return
