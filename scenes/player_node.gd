extends Node3D
@onready var camera = $"Camera3D"
@onready var player = $"Player"
var initialCameraPos = Vector3()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialCameraPos = camera.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	camera.set_position(Vector3(initialCameraPos.x + player.position.x, initialCameraPos.y + player.position.y, initialCameraPos.z + player.position.z))
	camera.look_at(player.position)
