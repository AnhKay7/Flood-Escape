extends Control

@onready var back_button = $Control/MarginContainer/VBoxContainer/Buttons/BackButton

func _ready():
	# Kết nối tín hiệu (Signal) từ nút Back
	back_button.pressed.connect(_on_back_pressed)

func _on_back_pressed():
	# Chuyển về màn hình chính
	get_tree().change_scene_to_file("res://scenes/menu/MainMenu.tscn")
