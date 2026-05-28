extends Node2D

@onready var acid_water: Area2D = $AcidWater/Acid_Water
@onready var player: Player = $Player
@onready var music: AudioStreamPlayer = $Audio/MusicStart
@onready var music_end: AudioStreamPlayer = $Audio/MusicEnd
@onready var explosion: AudioStreamPlayer = $Audio/Explosion
@onready var cut_scene: AnimationPlayer = $CutScene/AnimationPlayer
@onready var playercamera: Camera2D = $Player/playercamera

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
	
	explosion.play()
	await get_tree().create_timer(2.0).timeout
		
	
func _on_button_2_cutscene_triggered() -> void:
	#trigger_factory_collapse()
	cut_scene.play("water_scene")
	await cut_scene.animation_finished
	if music:
		music.play()
	if acid_water:
		acid_water.is_active = true
	pass

func _on_finish_line_body_entered(body: Node2D) -> void:
	if body.name == "Player" and is_level_cleared == false:
		music.stop()
		is_level_cleared = true
		await music_end.finished
		print("STAGE CLEAR!!!")
		await get_tree().create_timer(3.0).timeout
		get_tree().paused = true
		pass
	pass


func _on_elevator_trigger_cutscene_triggered() -> void:
	cut_scene.play("elevator")
	await cut_scene.animation_finished
	pass # Replace with function body.


func _on_pre_elevator_trigger_pre_elevator_reached() -> void:
	cut_scene.play("pre_elevator_door")
	if music and music.playing:
		var audio_tween = create_tween()
		audio_tween.tween_property(music, "volume_db", -10.0, 1.5)
		await audio_tween.finished
		#music.stop()
	pass # Replace with function body.
