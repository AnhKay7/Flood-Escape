extends Control

@onready var back_button = $BackBtn

func _ready():
	# Kết nối tín hiệu (Signal) từ nút Back
	back_button.pressed.connect(_on_back_pressed)

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/menu/MainMenu.tscn")
