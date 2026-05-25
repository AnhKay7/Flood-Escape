extends PlayerState

@onready var landing: AudioStreamPlayer = $"../../Audio/Landing"
@onready var foot_step: AudioStreamPlayer = $"../../Audio/FootStep"


func enter(previous_state_path : String, data = {}):
	if (previous_state_path == FALL):
		landing.play()
	player.animated_sprite_2d.play("run")
	
func physics_update(delta: float) -> void:
	
	player.direction = Input.get_axis("left", "right")
	player.velocity.x = move_toward(player.velocity.x, player.direction * player.SPEED, player.ACCELERATION * delta)
	player.velocity.y += player.GRAVITY * delta;
	
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
	
	
func _on_animated_sprite_2d_frame_changed() -> void:
	if not player.animated_sprite_2d.animation == "run":
		return
	if player.animated_sprite_2d.frame == 0 || player.animated_sprite_2d.frame == 2 || player.animated_sprite_2d.frame == 4:
		foot_step.play()
	pass # Replace with function body.
