extends Control  
  
func _ready():  
	# Kết nối tín hiệu (Signal) từ các nút  
	$MarginContainer/VBoxContainer/ButtonsVBox/PlayButton.pressed.connect(_on_play_pressed)  
	$MarginContainer/VBoxContainer/ButtonsVBox/ExitButton.pressed.connect(_on_exit_pressed)  
  
func _on_play_pressed():  
	# In ra console khi bắt đầu game  
	print("Starting Game...")  
	  
	# Đợi 0.5 giây trước khi chuyển cảnh  
	await get_tree().create_timer(0.5).timeout  
	  
	# Chuyển sang level đầu tiên  
	get_tree().change_scene_to_file("res://levels/level_1.tscn")  
  
func _on_exit_pressed():  
	# Đóng ứng dụng  
	get_tree().quit()
