extends Control

@onready var back_button = $BackBtn
var master_bus = AudioServer.get_bus_index("Master")

func _ready():
	# Kết nối tín hiệu (Signal) từ nút Back
	back_button.pressed.connect(_on_back_pressed)
	var current_vol = AudioServer.get_bus_volume_db(master_bus)
	$MarginContainer/PanelContainer/VBoxContainer/HScrollBar/VBoxContainer/Volume/VolumeSlider.value = db_to_linear(current_vol)

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")


func _on_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(master_bus, linear_to_db(value))
	AudioServer.set_bus_mute(master_bus, value == 0.0)
	pass # Replace with function body.
