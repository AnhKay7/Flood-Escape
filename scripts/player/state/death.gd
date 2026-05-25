extends PlayerState

@onready var hurt: AudioStreamPlayer2D = $"../../Audio/Hurt"

func handle_music() -> void:
	hurt.play()
	var bus_index = AudioServer.get_bus_index("Music")
	var low_pass_effect = AudioServer.get_bus_effect(bus_index, 0)
	AudioServer.set_bus_effect_enabled(bus_index, 0, true)
	var audio_tween = create_tween()
	audio_tween.tween_property(low_pass_effect, "cutoff_hz", 300.0, 1.5)
	pass
func handle_camera() -> void:
	var camera = owner.get_node_or_null("Camera2D")
	if camera:
		var tween = create_tween()
		tween.tween_property(camera, "zoom", Vector2(1.5, 1.5), 0.1)
		if camera and camera.has_method("start_screen_shake"):
			camera.start_screen_shake(10.0, 0.2)
	pass
func handle_animation(dir_x: int) -> void:
	if owner.has_node("ExplosionParticles"):
		var fake_sprite = owner.get_node("ExplosionParticles")
		if dir_x < 0:
			fake_sprite.scale.x = -1
		elif dir_x > 0:
			fake_sprite.scale.x = 1
		fake_sprite.direction = Vector2(abs(dir_x) * 0.5, -1)
		fake_sprite.emitting = true
	pass
func enter(previous_state_path: String, data = {}) -> void:
	
	var dir_x = sign(player.facing_diraction)
	player.velocity = Vector2.ZERO
	player.animated_sprite_2d.play("hurt")
	
	handle_music()
	handle_camera()
	
	player.animated_sprite_2d.visible = false
	
	handle_animation(dir_x)
	
	await get_tree().create_timer(1.5, true, false, true).timeout
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()
	pass
	
func physics_update(delta: float) -> void:
	
	player.velocity = Vector2.ZERO
	pass
