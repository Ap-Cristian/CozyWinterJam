extends CanvasLayer

@onready var wood_pieces = $WoodPieces;
@onready var fire_strength = $FireStrength;
@onready var fire_interactable = $FireInteractableNotice;

func _ready():
	fire_strength.size = Vector2(300, 60);

func update_wood_pieces(pieces: int):
	wood_pieces.text = str(pieces);
	
func update_fire_strength(strength):
	fire_strength.value = strength;

func update_fire_interactable(status: bool):
	if status:
		fire_interactable.text = "Press E to fuck my shitass ahhh";
	else:
		fire_interactable.text = "";
