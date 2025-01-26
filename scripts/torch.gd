extends Node3D
@onready var ui = $"../../../../UI"
@onready var torchLight = $"TorchTip/TorchLight"
@onready var player = $"../../"
@onready var safeZone = $"../../../../SafeZone/CollisionShape3D"
@onready var fire = $"../../../../Fire"
@onready var fireParticles = $"FireParticles"
@onready var smokeParticles = $"SmokeParticles"

var nodeHelper = preload("res://scripts/helpers/node_helpers.gd").new();
var torch_strength = 1.0;
var decrease_modifier = 0.05;

func kill_torch():
	fireParticles.emitting = false;
	smokeParticles.emitting = false;

func update_torch(delta):
	if (torch_strength - decrease_modifier * delta) >= 0:
		torch_strength -= decrease_modifier * delta;
		ui.update_torch_strength(torch_strength);
		torchLight.light_energy = torch_strength;
	else:
		kill_torch();
	
	if(fire.dead):
		kill_torch();
		self.visible = false;

func replenish_strength():
	fireParticles.emitting = true;
	smokeParticles.emitting = true;
	torch_strength = 1.0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var safeZoneOrigin = [safeZone.position.x,safeZone.position.z];
	var safeZoneRadius = safeZone.shape.radius;
	if nodeHelper.is_node_in_zone(player, safeZoneOrigin, safeZoneRadius):
		replenish_strength();
	update_torch(delta);
