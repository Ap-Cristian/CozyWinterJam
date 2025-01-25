extends Node3D
@onready var camera = $"Player/Camera3D"
@onready var player = $"Player"
@onready var ambient_sound = $"../AmbientSound";
@onready var safezone = get_parent().get_node("SafeZone")
var nodeHelper = preload("res://scripts/helpers/node_helpers.gd").new();
var initialCameraPos = Vector3()

var exclusionList = []

var game_started = false;

func has_game_started():
	return game_started;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialCameraPos = camera.position

func getMousePos() -> Vector2:
	return get_viewport().get_mouse_position()
	
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not game_started:
		var safezone_radius = safezone.get_child(1).shape.radius;
		var dist = nodeHelper.get_distance_between_points([player.position.x, player.position.z], [safezone.position.x, safezone.position.z]);
		if dist > safezone_radius:
			ambient_sound.play();
			game_started = true;
		
	var space_state = get_world_3d().direct_space_state
	var mouse_pos = getMousePos();
	var rayOrigin = camera.project_ray_origin(mouse_pos);
	var rayEnd = rayOrigin + camera.project_ray_normal(mouse_pos) * 2000;

	var exclude = [];
	var query = PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd);
	query.set_exclude(exclude);
	var intersection = space_state.intersect_ray(query);

	var intersection_pos = null;
	while "collider" in intersection:
		var collider_path = intersection.collider.get_path();
		var full_node_path = collider_path.get_concatenated_names();

		if full_node_path.begins_with("root/Main/Ground"):
			intersection_pos = intersection.position;
			break ;

		exclude.append(intersection.get("rid"))
		query.set_exclude(exclude)
		intersection = space_state.intersect_ray(query)

	if intersection_pos == null:
		return ;
			
	#$Player.look_at(Vector3(intersection_pos.x, intersection_pos.y, intersection_pos.z), Vector3(0, 1, 0))
	#camera.set_position(
		#Vector3(initialCameraPos.x + player.position.x, initialCameraPos.y + player.position.y, initialCameraPos.z + player.position.z)
	#)
	#camera.look_at(player.position)
