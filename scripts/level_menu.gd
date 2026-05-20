extends Control

@onready var back_button = $Control/BackBtn
@onready var lv1_button = $Control/MarginContainer/VBoxContainer/VScrollBar/GridContainer/Level1Btn
@onready var lv2_button = $Control/MarginContainer/VBoxContainer/VScrollBar/GridContainer/Level2Btn

func _ready():
	# Kết nối tín hiệu (Signal) từ nút Back
	back_button.pressed.connect(_on_back_pressed)
	lv1_button.pressed.connect(_on_lv1_pressed)
	
func _on_lv1_pressed():
	# Chuyển về màn hình chính
	get_tree().change_scene_to_file("res://scenes/Level/Level1/Level1.tscn")

func _on_back_pressed():
	# Chuyển về màn hình chính
	get_tree().change_scene_to_file("res://scenes/menu/MainMenu.tscn")
