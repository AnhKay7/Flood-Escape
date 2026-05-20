extends Control

@onready var play_button = $Control/MarginContainer/VBoxContainer/Buttons/PlayButton
@onready var exit_button = $Control/MarginContainer/VBoxContainer/Buttons/ExitButton
@onready var setting_button = $Control/MarginContainer/VBoxContainer/Buttons/SettingsButton

func _ready():
	# Kết nối tín hiệu (Signal) từ các nút
	play_button.pressed.connect(_on_play_pressed)
	exit_button.pressed.connect(_on_exit_pressed)
	setting_button.pressed.connect(_on_setting_pressed)

func _on_play_pressed():
	# In ra console khi bắt đầu game
	print("Starting Game...")

	# Chuyển sang level đầu tiên
	get_tree().change_scene_to_file("res://scenes/menu/LevelsMenu.tscn")

func _on_setting_pressed():
	get_tree().change_scene_to_file("res://scenes/menu/Settings.tscn")

func _on_exit_pressed():
	# Đóng ứng dụng
	get_tree().quit()
