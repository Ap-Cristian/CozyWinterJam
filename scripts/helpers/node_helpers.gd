func spawn_prefab(x: float, z: float, prefab: Node, parent: Node):
	prefab.position = Vector3(x, 2, z);
	parent.add_child(prefab);

func get_rand_coords_on_ground(ground: Node) -> Array:
	var ground_size = ground.get_aabb();
	
	var x_range = [ground_size.position.x, ground_size.end.x];
	var z_range = [ground_size.position.z, ground_size.end.z];

	var x = randf_range(x_range[0], x_range[1]);
	var z = randf_range(z_range[0], z_range[1]);
	
	return [x,z]
	
func get_distance_between_points(a: Array, b: Array) -> float:
	return sqrt(pow((b[0] - a[0]) + (b[1] - a[1]), 2))

func get_rand_coords_on_ground_outside_zone(ground: Node, zone_origin: Array, zone_radius) -> Array:
	var ground_size = ground.get_aabb();
	
	var x_range = [ground_size.position.x, ground_size.end.x];
	var z_range = [ground_size.position.z, ground_size.end.z];

	var x = randf_range(x_range[0], x_range[1]);
	var z = randf_range(z_range[0], z_range[1]);
	var zone_origin_to_point_distance = get_distance_between_points(zone_origin, [x,z])

	while zone_origin_to_point_distance < zone_radius:
		x = randf_range(x_range[0], x_range[1]);
		z = randf_range(z_range[0], z_range[1]);
		zone_origin_to_point_distance = get_distance_between_points(zone_origin, [x,z])
		
	#
	return [x,z]
