extends Node3D

var tree_prefab = preload("res://prefabs/tree.tscn");
var nodeHelper = preload("res://scripts/helpers/node_helpers.gd").new();
const TREE_DENSITY = 100000;

@onready var ground = get_parent().get_node("Ground/Ground");
@onready var safeZone = get_parent().get_node("SafeZone");

@onready var managerNode = $"."

func spawnTrees():
	var safeZoneShape = safeZone.get_node("CollisionShape3D").get_shape();
	var safeZoneOrigin = [safeZone.position.x, safeZone.position.z];
	
	print(safeZoneOrigin)
	for i in range(0, TREE_DENSITY):
		var coords = nodeHelper.get_rand_coords_on_ground_outside_zone(ground, safeZoneOrigin, safeZoneShape.radius)
		nodeHelper.spawn_prefab(coords[0], coords[1], tree_prefab.instantiate(), managerNode)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawnTrees()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
