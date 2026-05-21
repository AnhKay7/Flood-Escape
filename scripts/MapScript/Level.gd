extends Node2D

@export var water_timeline: Array[Dictionary] = []

func _ready() -> void:
	await get_tree().process_frame
	start_water_sequence()

func start_water_sequence() -> void:
	# Duyệt qua từng giai đoạn đã cài đặt trong mảng timeline
	for phase in water_timeline:
		var duration: float = phase.get("duration", 5.0)
		var action: String = phase.get("action", "stop")
		var speed: float = phase.get("speed", 20.0)
		if Water.instance:
			if action == "rise":
				Water.instance.start_rising(speed)
			elif action == "stop":
				Water.instance.stop_rising()
		await get_tree().create_timer(duration).timeout
