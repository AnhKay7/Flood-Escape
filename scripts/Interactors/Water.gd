extends TileMapLayer

signal player_died

@export var default_rise_speed: float = 20.0       
@export var default_lower_amount: float = 50.0     

var current_rise_speed: float = 0.0
var is_rising: bool = false
var is_lowering: bool = false 

static var instance: TileMapLayer

func _enter_tree() -> void:
	instance = self

func _process(delta: float) -> void:
	# CHỈ ĐƯỢC PHÉP dâng nước nếu đang bật is_rising VÀ KHÔNG BỊ KHÓA bởi lệnh hạ nước
	if is_rising and not is_lowering:
		position.y -= current_rise_speed * delta

# --- Chức năng cho Level Script gọi từ xa ---
func start_rising(new_speed: float = default_rise_speed) -> void:
	current_rise_speed = new_speed
	is_rising = true

func stop_rising() -> void:
	is_rising = false

# --- Chức năng cho Nút bấm gọi từ xa ---
func lower_water(custom_amount: float = default_lower_amount, lower_speed: float = 100.0) -> void:
	# Bật khóa: Đóng băng ngay lập tức lệnh dâng nước trong _process
	is_lowering = true
	var target_y: float = position.y + custom_amount
	var duration: float = custom_amount / lower_speed
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	# Tween thực hiện hạ nước mượt mà không lo bị _process đè tọa độ
	tween.tween_property(self, "position:y", target_y, duration)
	# Khi Tween chạy xong hoàn toàn (nước đã hạ đến đích)
	# Gọi hàm callback này để mở khóa, cho phép _process tiếp tục dâng nước từ vị trí mới
	tween.tween_callback(func(): is_lowering = false)
	
	print("Singleton Water: Đang hạ nước từ từ xuống ", custom_amount, " px với tốc độ ", lower_speed, "/s.")
