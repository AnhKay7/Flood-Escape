class_name PlayerState extends State

const IDLE = "Idle"
const RUN = "Run"
const JUMP = "Jump"
const FALL = "Fall"
const DASH = "Dash"
const WALL_CLIMB = "WallClimb"
const DEATH = "Death"
var player: Player

func _ready() -> void:
	await owner.ready
	player = owner as Player
	#debug code
	assert(player != null, "bien player khong duoc phep rong. Bat buoc phai chua 1 Player")
