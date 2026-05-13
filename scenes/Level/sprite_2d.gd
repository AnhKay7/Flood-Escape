extends Sprite2D

func _init() -> void:
	print("constructed")
	
func _ready() -> void:
	print("Tina san sang")

func _process(delta: float) -> void:
	# 1. Cập nhật Label để theo dõi tọa độ X thực tế
	$Label.text = str(position.x)
	
	# 2. Di chuyển Sprite sang phải
	position.x += 100 * delta
	
	# 3. Kiểm tra nếu tọa độ x vượt quá 300 thì xóa object
	if position.x > 300:
		queue_free()

func _exit_tree() -> void:
	print("destroyed")
