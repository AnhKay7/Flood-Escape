extends Control

# Đường dẫn đến màn chơi đầu tiên
@export var first_level_path: String = "res://scenes/levels/level_1.tscn"

func _ready():
	# Kết nối tín hiệu (Signal) từ các nút
	$MarginContainer/VBoxContainer/ButtonsVBox/PlayButton.pressed.connect(_on_play_pressed)
	$MarginContainer/VBoxContainer/ButtonsVBox/ExitButton.pressed.connect(_on_exit_pressed)

func _on_play_pressed():
	# Hiệu ứng chuyển cảnh
	get_tree().change_scene_to_file(first_level_path)

func _on_exit_pressed():
	get_tree().quit()
