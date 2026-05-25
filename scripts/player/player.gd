class_name Player extends BaseCharacter


func _ready() -> void:
	
	pass

func _on_hurtbox_body_entered(body: Node2D) -> void:
	print("ENTER DEAD ZONE")
	if state_machine:
		state_machine._transition_to_next_state("Death")

func _on_water_trigger_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_acid_water_area_entered(area: Area2D) -> void:
	pass # Replace with function body.


func _on_button_1_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
