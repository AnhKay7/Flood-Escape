extends Node

# Cho phép chọn trạng thái bắt đầu (thường là Idle) từ tab Inspector
@export var initial_state: State

var current_state: State
var states: Dictionary = {}

func _ready() -> void:
	# Lấy tham chiếu đến Node gốc (Player)
	var player = get_parent() as CharacterBody2D
	
	# Quét tất cả các node con nằm trong StateMachine
	for child in get_children():
		if child is State:
			# Lưu trạng thái vào từ điển để dễ tìm kiếm bằng tên (viết thường hết cho an toàn)
			states[child.name.to_lower()] = child
			
			# Chuyển quyền điều khiển Player cho các trạng thái con
			child.player = player
			
			# Kết nối tín hiệu chuyển trạng thái
			child.Transitioned.connect(on_child_transition)
	
	# Khởi động trạng thái đầu tiên khi game bắt đầu
	if initial_state:
		initial_state.enter()
		current_state = initial_state

# Người quản lý gọi hàm update của trạng thái hiện tại
func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

# Người quản lý gọi hàm physics_update của trạng thái hiện tại
func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

# Hàm này sẽ kích hoạt khi nhận được tín hiệu xin chuyển trạng thái từ một State con
func on_child_transition(state: State, new_state_name: String) -> void:
	# Đề phòng lỗi: Chỉ cho phép trạng thái HIỆN TẠI được quyền xin chuyển
	if state != current_state:
		return
	
	# Tìm trạng thái mới trong từ điển
	var new_state = states.get(new_state_name.to_lower())
	if not new_state:
		push_warning("Lỗi: Không tìm thấy state có tên -> ", new_state_name)
		return
	
	# Dọn dẹp trạng thái cũ (chạy hàm exit)
	if current_state:
		current_state.exit()
	
	# Bước vào trạng thái mới và cập nhật biến current_state
	new_state.enter()
	current_state = new_state
