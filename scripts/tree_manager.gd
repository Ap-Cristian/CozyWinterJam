extends Node3D

const TREE_DENSITY = 800;
const MAX_NUMBER_OF_ATTEMPTS = 20;

var tree_prefab = preload("res://prefabs/tree.tscn");
var nodeHelper = preload("res://scripts/helpers/node_helpers.gd").new();
var rng = RandomNumberGenerator.new();
var trees = [];

@onready var ground = get_parent().get_node("Ground/Ground");
@onready var safeZone = get_parent().get_node("SafeZone");
@onready var managerNode = $".";

func spawnTrees():
	var safeZoneShape = safeZone.get_node("CollisionShape3D").get_shape();
	var safeZoneOrigin = [safeZone.position.x, safeZone.position.z];
	
	for i in range(0, TREE_DENSITY):
		var coords = nodeHelper.get_rand_coords_on_ground_outside_zone(ground, safeZoneOrigin, safeZoneShape.radius)
		var tree = nodeHelper.spawn_prefab(coords[0], coords[1], tree_prefab.instantiate(), managerNode)
		
		var scale = rng.randf_range(0.6, 1.2);
		var degrees = rng.randf_range(0,360);
		tree.scale.x = scale;
		tree.scale.y = scale;
		tree.scale.z = scale;
		tree.rotation.y = degrees;
		
		var okToAdd = false;
		var attemptNumber = 0;
		
		if not trees.is_empty():
			while not okToAdd and attemptNumber < MAX_NUMBER_OF_ATTEMPTS:
				for treeInstanced in trees:
					var treeOrigin = [treeInstanced.position.x, treeInstanced.position.z];
					var treeRadius = treeInstanced.get_node("StaticBody3D/CollisionShape3D").shape.radius;
					
					if nodeHelper.is_node_in_zone(tree, treeOrigin, treeRadius):
						coords = nodeHelper.get_rand_coords_on_ground_outside_zone(ground, safeZoneOrigin, safeZoneShape.radius);
						tree.set_position(Vector3(coords[0], 0, coords[1]));
						break
						
					if(trees.find(treeInstanced) == trees.size() - 1):
						okToAdd = true;
				attemptNumber += 1;
				
			if(okToAdd):
				trees.append(tree);
			else:
				print("Tree ran out of space...");
				tree.queue_free()
		else:
			trees.append(tree);

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawnTrees();
	print("number_of_trees_expected:", TREE_DENSITY);
	print("number_of_trees_actual:", trees.size());

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
