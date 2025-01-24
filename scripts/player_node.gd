extends Node3D
@onready var camera = $"Camera3D"
@onready var player = $"Player"
var initialCameraPos = Vector3()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialCameraPos = camera.position

func getMousePos() -> Vector2:
	return get_viewport().get_mouse_position()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var space_state = get_world_3d().direct_space_state
	var mousePos = getMousePos()
	var rayOrigin = camera.project_ray_origin(mousePos)
	var rayEnd = rayOrigin + camera.project_ray_normal(mousePos) * 2000
	var intersection = space_state.intersect_ray(PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd))

	if not intersection.is_empty() and intersection.collider.name == "Ground":
		var pos = intersection.position
		$Player.look_at(Vector3(pos.x, pos.y, pos.z), Vector3(0,1,0))
	
	camera.set_position(
		Vector3(initialCameraPos.x + player.position.x, initialCameraPos.y + player.position.y, initialCameraPos.z + player.position.z)
		)
	camera.look_at(player.position)
