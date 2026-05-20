class_name StateMachine extends Node

@export var initial_state: State = null

@onready var state: State = (func get_initial_state() -> State: 
	return initial_state if initial_state != null else get_child(0)
	).call()
	
func _ready() -> void:
	#find_children("*", "State") == tìm và lấy tất cả con bất kể tên gì (*) miễn là State
	for state_node: State in find_children("*", "State"):
		state_node.finished.connect(_transition_to_next_state)
	
	await owner.ready #Doi Player lay du lieu xong
	state.enter("")

func _transition_to_next_state(target_state_path: String, data: Dictionary = {}) -> void:
	if not has_node(target_state_path):
		printerr(owner.name + ": Co doi trang thai toi " + target_state_path + " nhung khong ton tai trang thai nay.")
		return
	
	var previous_state_path := state.name
	state.exit()
	state = get_node(target_state_path)
	state.enter(previous_state_path, data)

#_unhandled_input thay do input vi unhandled input chi truyen doan ngan -> tranh nhieu nguon nhan cung input
func _unhandled_input(event: InputEvent) -> void:
	state.handle_input(event)

func _process(delta: float) -> void:
	state.update(delta)

func _physics_process(delta: float) -> void:
	state.physics_update(delta)
