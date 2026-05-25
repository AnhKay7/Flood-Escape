extends Camera2D

var shake_intensity: float = 0.0

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
