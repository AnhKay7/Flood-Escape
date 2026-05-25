extends PlayerState

@onready var dash: AudioStreamPlayer = $"../../Audio/Dash"

func enter(previous_state_path: String, data = {}) -> void:
	player.velocity.x = 0
	player.animated_sprite_2d.play("idle")
	pass

func exit() -> void:
	pass

func physics_update(delta: float) -> void:
		
	player.velocity.y += player.GRAVITY * delta
	player.velocity.y = min(player.velocity.y, player.MAX_FALL_SPEED) 
	
	
	
	
