extends Area2D
func _ready() -> void:
	# Kết nối sự kiện va chạm vật lý của chính Area2D này
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	# Kiểm tra xem thứ chạm vào nước có phải là Player không
	if body.is_in_group("Player") or body.name == "Player":
		# Bắn tín hiệu chết từ Singleton ra cho toàn game biết
		if Water.instance:
			Water.instance.player_died.emit()
		# Kích hoạt hàm chết trực tiếp trên Player
		if body.has_method("die"):
			body.die()
