extends PlayerState

func enter(previous_state_path: String, data = {}) -> void:
	player.velocity.x = 0.0
	player.animated_sprite_2d.play("idle")

func physics_update(delta: float) -> void:
	player.velocity.x = move_toward(player.velocity.x, 0, player.FRICTION * delta)
	player.velocity.y += player.get_gravity().y * delta
	
	if not player.is_on_floor():
		finished.emit(FALL)
		return
	
	if Input.is_action_just_pressed("jump"):
		finished.emit(JUMP)
		return
	
	if Input.is_action_just_pressed("dash"):
		finished.emit(DASH)
	
	if player.is_on_floor() and Input.get_axis("left", "right"):
		finished.emit(RUN)
