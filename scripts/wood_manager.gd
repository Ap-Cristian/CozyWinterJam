extends Node3D

@onready var camera = $"../Player_Node/Camera3D"

var wood_scene = preload("res://scenes/wood.tscn");

func spawn_wood(x: float, z: float):
	var obj = wood_scene.instantiate();
	obj.position = Vector3(x, 0, z);
	self.add_child(obj);

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var ground_node = get_parent().get_node("Ground/Ground");
	var ground_size = ground_node.get_aabb();
	
	var x_range = [ground_size.position.x, ground_size.end.x];
	var z_range = [ground_size.position.z, ground_size.end.z];
	
	for i in range(0, 200):
		var x = randf_range(x_range[0], x_range[1]);
		var z = randf_range(z_range[0], z_range[1]);
		spawn_wood(x, z);
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	var space_state = get_world_3d().direct_space_state
	var mousePos = get_viewport().get_mouse_position();
	var rayOrigin = camera.project_ray_origin(mousePos);
	var rayEnd = rayOrigin + camera.project_ray_normal(mousePos) * 2000;
	var intersection = space_state.intersect_ray(PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd));
	
	for child in self.get_children():
		var mesh = child.get_node("RigidBody3D/MeshInstance3D");
		if mesh.mesh.material.next_pass.get_shader_parameter("on"):
			mesh.mesh.material.next_pass.set_shader_parameter("on", 0);
			
	if not "collider" in intersection:
		return;
		
	var collider_path = intersection.collider.get_path();
	var collider_path_name = collider_path.get_concatenated_names();
	if not collider_path_name.begins_with("root/Main/WoodManager/"):
		return;
		
	var hit_node = get_node(collider_path.slice(0, 4));
	var mesh = hit_node.get_node("RigidBody3D/MeshInstance3D");
	mesh.mesh.material.next_pass.set_shader_parameter("on", 1);
	
