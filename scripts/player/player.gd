class_name Player extends BaseCharacter

func _ready() -> void:
	
	pass


func _on_water_trigger_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_acid_water_area_entered(area: Area2D) -> void:
	pass # Replace with function body.


func _on_finish_line_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		get_tree().paused = true
		print("STAGE CLEAR!!!")
	pass # Replace with function body.


func _on_button_1_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
