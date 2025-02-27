extends CanvasLayer

@onready var fire_strength = $Fire/FireStrength;
@onready var fire_icon = $Fire/TextureRect;
@onready var torch_strength = $Torch/TorchStrength;
@onready var torch_icon = $Torch/TorchIcon;
@onready var fire_interactable = $FireInteractableNotice;
@onready var crosshair = $Crosshair;
@onready var death_text = $DeathText;
@onready var death_hint = $DeathHint;
@onready var death_stats = $DeathStats;
@onready var camera = $"../Player_Node/Player/Camera3D";
@onready var wood_manager = $"../WoodManager";
@onready var player = $"../Player_Node";

var do_death_animations = false;

var last_death_text_modulate = Color8(255, 255, 255, 0);
var init_camera_rotation_x = null;

func _ready():
	update_wood_pieces(0);
	update_fire_strength(1);
	
func _process(delta: float) -> void:
	if not do_death_animations:
		return;
		
	if last_death_text_modulate.a < 0.5:
		last_death_text_modulate.a += 0.1 * delta;
		death_text.modulate = last_death_text_modulate;
		death_stats.modulate = last_death_text_modulate;
	
	if camera.rotation.x < 1.5:
		var idk = 1;
		if init_camera_rotation_x < 0:
			idk = -1;
		var inc = lerpf(init_camera_rotation_x * idk, 1.5, 0.1) * delta;
		camera.rotate_x(inc);

func update_wood_pieces(pieces: int):
	update_fire_interactable(false, pieces, true);
	
func update_fire_strength(strength):
	fire_strength.value = strength;

func update_torch_strength(strength):
	torch_strength.value = strength;
	
func show_death_screen():
	fire_strength.visible = false;
	fire_interactable.visible = false;
	fire_icon.visible = false;
	torch_strength.visible = false;
	torch_icon.visible = false;
	crosshair.visible = false;
	death_text.visible = true;
	death_hint.visible = true;
	do_death_animations = true;
	
	var tmp = "";
	if wood_manager.get_wood_collected_during_game() == 1:
		tmp = " piece of wood";
	else:
		tmp = " pieces of wood";
		
	death_stats.text = "I survived for " +  str(player.get_alive_time()) + " seconds and burned " + str(wood_manager.get_wood_collected_during_game()) + tmp;
	init_camera_rotation_x = camera.rotation.x;

func update_fire_interactable(status: bool, wood_to_deposit: int, update_only_wood: bool = false):
	if update_only_wood:
		if fire_interactable.text != "":
			var end: String;
			if wood_to_deposit == 1:
				end = " wood piece";
			else:
				end = " wood pieces";

			fire_interactable.text = "Press E to burn " + str(wood_to_deposit) + end;
		return;
		
	if status:
		var end: String;
		if wood_to_deposit == 1:
			end = " wood piece";
		else:
			end = " wood pieces";

		fire_interactable.text = "Press E to burn " + str(wood_to_deposit) + end;
	else:
		fire_interactable.text = "";
