class_name Player extends BaseCharacter

func play_animation(animation_name: String) -> void:
	animated_sprite_2d.play(animation_name)
	pass
func stop_animation() -> void:
	animated_sprite_2d.stop()
	pass
func flip_sprite() -> void:
	if animated_sprite_2d.flip_h:
		animated_sprite_2d.flip_h = false
	else:
		animated_sprite_2d.flip_h = true
func set_state(state: String) -> void:
	if state_machine:
		state_machine._transition_to_next_state(state)
func set_flip(is_flipped: bool) -> void:
	animated_sprite_2d.flip_h = is_flipped
func _ready() -> void:
	
	pass

func _on_hurtbox_body_entered(body: Node2D) -> void:
	#print("ENTER DEAD ZONE")
	if state_machine:
		state_machine._transition_to_next_state("Death")

func _on_water_trigger_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_acid_water_area_entered(area: Area2D) -> void:
	pass # Replace with function body.


#region TIMER_MANAGEMENT
func Handle_Buffer(delta: float) -> void:
	##buffer
	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta
	if dash_buffer_timer > 0:
		dash_buffer_timer -= delta
	if is_on_wall_timer > 0:
		is_on_wall_timer -= delta
	if coyote_timer > 0:
		coyote_timer -= delta
	##skill cool-down
	if dash_cd_timer > 0: 
		dash_cd_timer -= delta 
	##duration
	if wall_jump_timer > 0:
		wall_jump_timer -= delta
	if dash_timer > 0:
		dash_timer -= delta
	##get buffer
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = MAX_JUMP_BUFFER_TIMER
	if Input.is_action_just_pressed("dash"):
		dash_buffer_timer = MAX_DASH_BUFFER_TIMER
	if is_on_wall():
		can_dash = true
		wall_direction = -get_wall_normal().x
		is_on_wall_timer = MAX_IS_ON_WALL_TIMER
	if is_on_floor():
		coyote_timer = MAX_COYOTE_TIMER
		can_dash = true
#endregion

# Hàm này sẽ được WATERAREA gọi trực tiếp khi Player chạm vào vùng va chạm
func die() -> void:
	# Logic xử lý cái chết (Hiệu ứng, load lại cảnh...)
	get_tree().call_deferred("reload_current_scene")
