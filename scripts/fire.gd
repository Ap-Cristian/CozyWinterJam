extends StaticBody3D

@onready var ui = $"../UI"
@onready var player = $"../Player_Node/Player";
@onready var player_node = $"../Player_Node";
@onready var wood_manager = $"../WoodManager";
@onready var audio_player = $"../AmbientSound";
@onready var fire_particles = $"FireParticles";
@onready var smoke_particles = $"SmokeParticles";

var wood_scene = preload("res://scenes/wood.tscn");
var nodeHelper = preload("res://scripts/helpers/node_helpers.gd").new();

const PLAYER_TO_FIRE_MIN_DISTNACE = 10;
const WARMNESS_PER_WOOD = 0.3;
const COLD_MODIFIER_INCREASE_PER_DEPOSIT = 0.003;
const WOOD_LOWERING_SPEED_INTO_FIRE = 3;

var fire_strength = 1.0;
var decrease_modifier = 0.015;
var dead = false;
var can_deposit = false;

var animated_wood = null;

signal fire_strength_updated
signal fire_interactable_updated

func die():
	fire_strength_updated.emit(0);
	fire_particles.emitting = false;
	smoke_particles.emitting = false;
	get_child(2).light_energy = 0;
	audio_player.stop();
	ui.show_death_screen();
	dead = true;
	
func are_we_dead_uwu():
	return dead;

func _input(event: InputEvent):
	if event is InputEventKey and event.pressed and event.keycode == KEY_E:
		if can_deposit:
			var wood_deposited = wood_manager.wood_deposit_all();
			fire_strength += min(wood_deposited * WARMNESS_PER_WOOD, 1 - fire_strength);
			fire_strength_updated.emit(fire_strength);
			can_deposit = false;
			fire_interactable_updated.emit(false, 0);
			decrease_modifier += COLD_MODIFIER_INCREASE_PER_DEPOSIT;

			var obj = wood_scene.instantiate();
			obj.position = Vector3(self.position.x, self.position.y - 4, self.position.z);
			player_node.add_child(obj);
			animated_wood = obj;
			animated_wood.get_child(0).get_child(1).disabled = true;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fire_strength_updated.connect(ui.update_fire_strength);
	fire_interactable_updated.connect(ui.update_fire_interactable);
	get_child(2).light_energy = 2 + 130 * 1;
	
func distance_between_player_and_fire() -> float:
	var fireOrigin = [$"CollisionShape3D".position.x, $"CollisionShape3D".position.z];
	var playerOrigin = [player.position.x, player.position.z];
	
	return nodeHelper.get_distance_between_points(fireOrigin, playerOrigin);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not player_node.has_game_started():
		return;
		
	fire_strength -= decrease_modifier * delta;
	if fire_strength <= 0:
		if not dead:
			die();
		return;
	
	if animated_wood != null:
		if animated_wood.position.y < self.position.y - 6.5:
			animated_wood.queue_free();
			animated_wood = null;
		else:
			animated_wood.position.y = move_toward(animated_wood.position.y, self.position.y - 7, WOOD_LOWERING_SPEED_INTO_FIRE * delta);
			var scale = move_toward(animated_wood.scale.x, 0, WOOD_LOWERING_SPEED_INTO_FIRE * delta);
			animated_wood.scale = Vector3(scale, scale, scale);

	fire_strength_updated.emit(fire_strength);
	get_child(2).light_energy = 2 + 130 * fire_strength;
	audio_player.volume_db = -10 - 30 * (1 - fire_strength) - distance_between_player_and_fire();
	
	var d2 = self.global_transform.origin
	if player.global_transform.origin.distance_to(d2) < PLAYER_TO_FIRE_MIN_DISTNACE:
		if not can_deposit and wood_manager.get_wood_in_inventory() > 0:
			fire_interactable_updated.emit(true, wood_manager.get_wood_in_inventory());
			can_deposit = true;
	elif can_deposit:
		can_deposit = false;
		fire_interactable_updated.emit(false, 0);
