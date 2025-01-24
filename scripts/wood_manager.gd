extends Node3D

@onready var camera = $"../Player_Node/Camera3D"
@onready var player = $"../Player_Node/Player";
@onready var ui = $"../UI"

const PLAYER_WOOD_MIN_DIST = 5;

var wood_scene = preload("res://scenes/wood.tscn");
var focused_wood_node = null;
var wood_in_inventory = 0;

signal wood_updated

func get_wood_in_inventory():
	return wood_in_inventory;

func wood_deposit_all():
	var ret = wood_in_inventory;
	wood_in_inventory = 0;
	wood_updated.emit(wood_in_inventory);
	return ret;

func mouse_colliding_with_wood(mouse_pos: Vector2):
	var space_state = get_world_3d().direct_space_state
	var rayOrigin = camera.project_ray_origin(mouse_pos);
	var rayEnd = rayOrigin + camera.project_ray_normal(mouse_pos) * 2000;

	var exclude = [];
	var query = PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd);
	query.set_exclude(exclude);
	var intersection = space_state.intersect_ray(query);
	
	var hit_node = null;

	while "collider" in intersection:
		var collider_path = intersection.collider.get_path();
		var full_node_path = collider_path.get_concatenated_names();
		
		# we hit what we are looking for
		if full_node_path.begins_with("root/Main/WoodManager/"):
			var node = get_node(collider_path.slice(0, 4));
			var d1 = player.global_transform.origin
			var d2 = node.get_child(0).global_transform.origin
			var d = d1.distance_to(d2)
			if d < PLAYER_WOOD_MIN_DIST:
				hit_node = node;
			break ;

		exclude.append(intersection.get("rid"))
		query.set_exclude(exclude)
		intersection = space_state.intersect_ray(query)

	return hit_node;

func _input(event: InputEvent) -> void:

	if event is InputEventMouseMotion:

		focused_wood_node = mouse_colliding_with_wood(event.position);
		
		for child in self.get_children():
			if focused_wood_node != null and child.get_path() == focused_wood_node.get_path():
				child.get_node("RigidBody3D/MeshInstance3D").mesh.material.next_pass.set_shader_parameter("on", 1);
			else:
				var mesh = child.get_node("RigidBody3D/MeshInstance3D");
				if mesh.mesh.material.next_pass.get_shader_parameter("on"):
					mesh.mesh.material.next_pass.set_shader_parameter("on", 0);

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed() && not event.is_echo():
			if focused_wood_node != null:
				var d1 = player.global_transform.origin
				var d2 = focused_wood_node.get_child(0).global_transform.origin
				var d = d1.distance_to(d2)
				if d < PLAYER_WOOD_MIN_DIST:
					wood_in_inventory += 1;
					wood_updated.emit(wood_in_inventory);
					focused_wood_node.queue_free();


func spawn_wood(x: float, z: float):
	var obj = wood_scene.instantiate();
	obj.position = Vector3(x, 0, z);
	obj.rotation = Vector3(0, randf_range(0, 360), 0);
	self.add_child(obj);

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var ground_node = get_parent().get_node("Ground/Ground");
	var ground_size = ground_node.get_aabb();

	wood_updated.connect(ui.update_wood_pieces);
	
	var x_range = [ground_size.position.x, ground_size.end.x];
	var z_range = [ground_size.position.z, ground_size.end.z];
	
	for i in range(0, 200):
		var x = randf_range(x_range[0], x_range[1]);
		var z = randf_range(z_range[0], z_range[1]);
		spawn_wood(x, z);
