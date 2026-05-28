extends Camera2D

var shake_intensity: float = 0.0

func change_to_player_camera() -> void:

	var current_cam = get_viewport().get_camera_2d()
	
	if current_cam and current_cam != self:
		var tween = create_tween()
		
		tween.tween_property(current_cam, "global_position", self.global_position, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		
		await tween.finished
		
	make_current()
func start_screen_shake(intensity: float, duration: float) -> void:
	shake_intensity = intensity
	var tween = create_tween()
	tween.tween_property(self, "shake_intensity", 0.0, duration)

func _process(delta: float) -> void:
	if shake_intensity > 0:
		# Thay vì dùng camera.offset, bây giờ chính nó là camera rồi nên gọi thẳng offset
		offset = Vector2(
			randf_range(-shake_intensity, shake_intensity),
			randf_range(-shake_intensity, shake_intensity)
		)
	else:
		offset = Vector2.ZERO
