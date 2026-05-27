extends Control

@onready var back_button = $Control/BackBtn
@onready var lv1_button = $Control/MarginContainer/VBoxContainer/VScrollBar/GridContainer/Level1Btn
@onready var lv2_button = $Control/MarginContainer/VBoxContainer/VScrollBar/GridContainer/Level2Btn
@onready var lv3_button = $Control/MarginContainer/VBoxContainer/VScrollBar/GridContainer/Level3Btn

func _ready():
	back_button.pressed.connect(_on_back_pressed)
	lv1_button.pressed.connect(_on_lv1_pressed)
	lv2_button.pressed.connect(_on_lv2_pressed)
	lv3_button.pressed.connect(_on_lv3_pressed)
	
func _on_lv1_pressed():
	get_tree().change_scene_to_file("res://scenes/Level/Level1/Level1.tscn")
	
func _on_lv2_pressed():
	get_tree().change_scene_to_file("res://scenes/Level/Level2/Level2.tscn")
	
func _on_lv3_pressed():
	get_tree().change_scene_to_file("res://scenes/Level/Level3/Level3.tscn")

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/menu/MainMenu.tscn")
