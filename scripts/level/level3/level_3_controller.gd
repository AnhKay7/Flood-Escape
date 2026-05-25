extends Node2D

@onready var acid_water: Area2D = $AcidWater/Acid_Water
@onready var camera: Camera2D = $Player/Camera2D
@onready var player: Player = $Player
@onready var music: AudioStreamPlayer = $Audio/MusicStart
@onready var music_end: AudioStreamPlayer = $Audio/MusicEnd
var is_level_cleared: bool = false

func _ready() -> void:
	var bus_index = AudioServer.get_bus_index("Music")
	var low_pass_effect = AudioServer.get_bus_effect(bus_index, 0)
	AudioServer.set_bus_effect_enabled(bus_index, 0, false)
	low_pass_effect.cutoff_hz = 3000
	pass 

func _process(delta: float) -> void:
	pass


func trigger_factory_collapse() -> void:
	print("HỆ THỐNG BÁO ĐỘNG: Động đất! Nước dâng!")
	
	if player:
		player.set_physics_process(false)
	if camera.has_method("start_screen_shake"):
		camera.start_screen_shake(15.0, 2.0)
	await get_tree().create_timer(2.0).timeout
	if music:
		music.play()
	if player:
		player.set_physics_process(true)
	if acid_water:
		acid_water.is_active = true
		
	# 2. Phát nguyên bài nhạc hoành tráng
	#$BGM_Escape.play()
	
	# 3. Rung camera (chúng ta sẽ làm bước này ngay sau khi bạn ghép nhạc xong)
	
func _on_button_2_cutscene_triggered() -> void:
	trigger_factory_collapse()
	pass # Replace with function body.

func _on_finish_line_body_entered(body: Node2D) -> void:
	if body.name == "Player" and is_level_cleared == false:
		music.stop()
		music_end.play()
		is_level_cleared = true
		
		acid_water.set_physics_process(false)
		
		await music_end.finished
		print("STAGE CLEAR!!!")
		get_tree().paused = true
		pass
	pass # Replace with function body.
