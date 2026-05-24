extends Node

# Mảng chứa danh sách vật thể cần xuất hiện/biến mất (Kéo thả từ Inspector)
@export var appear_list: Array[Node] = []
@export var fade_list: Array[Node] = []
@export var lower_value: float
@export var lower_speed: float

# Để an toàn, chúng ta xuất đường dẫn Node (NodePath) ra Inspector, tránh lỗi @onready bị nil
@export var sprite_waiting_path: NodePath
@export var sprite_deactivated_path: NodePath

var sprite_waiting: CanvasItem = null
var sprite_deactivated: CanvasItem = null
var is_pressed: bool = false


func _ready() -> void:
	# Kiểm tra và lấy Node an toàn, nếu sai đường dẫn game vẫn chạy bình thường không bị crash
	if has_node(sprite_waiting_path):
		sprite_waiting = get_node(sprite_waiting_path) as CanvasItem
		
	if has_node(sprite_deactivated_path):
		sprite_deactivated = get_node(sprite_deactivated_path) as CanvasItem

	# Đặt trạng thái ban đầu
	if is_instance_valid(sprite_waiting): 
		sprite_waiting.visible = true
	if is_instance_valid(sprite_deactivated): 
		sprite_deactivated.visible = false


# Kết nối tín hiệu body_entered của Area2D vào đây
func _on_body_entered(body: Node) -> void:
	# Kiểm tra nếu vật va chạm thuộc nhóm "Player" và nút chưa từng được nhấn
	if body.is_in_group("Player") and not is_pressed:
		is_pressed = true
		_activate_button()


# Hàm xử lý logic chính khi nút bị kích hoạt
func _activate_button() -> void:
	# 1. Tự biến đổi sprite của chính cái nút (Kiểm tra instance hợp lệ trước khi gọi)
	if is_instance_valid(sprite_waiting): 
		sprite_waiting.visible = false
	if is_instance_valid(sprite_deactivated): 
		sprite_deactivated.visible = true
	else:
		print("Khong thay after")
	
	# 2. Thực hiện chức năng APPEAR (Hiện lên + Bật va chạm)
	for node in appear_list:
		if is_instance_valid(node):
			_set_node_state(node, true)
			
	# 3. Thực hiện chức năng FADE (Ẩn đi + Tắt va chạm)
	for node in fade_list:
		if is_instance_valid(node):
			_set_node_state(node, false)
	# 4. Thực hiện chức năng hạ nước
	if Water.instance:
		Water.instance.lower_water(lower_value, lower_speed)


# Hàm phụ trợ để bật/tắt Visibility và Collision một cách an toàn
func _set_node_state(node: Node, active: bool) -> void:
	# Bật/Tắt hiển thị (Dành cho cả 2D và 3D)
	if node is CanvasItem or node is Node3D:
		node.visible = active

	# Trạng thái disable của collision (active = true thì disabled = false)
	var disable_collision: bool = not active
	
	if node is TileMapLayer:
		# Vì active = true thì physics_enabled = true (bật vật lý)
		node.set_deferred("collision_enabled", active)
