extends State

func enter() -> void:
	player.animated_sprite_2d.play("idle")
	
func physics_update(delta: float) -> void:
	
	player.velocity.x = move_toward(player.velocity.x, 0, player.FRI)
