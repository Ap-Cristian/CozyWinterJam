extends CanvasLayer

@onready var wood_pieces = $WoodPieces;
@onready var fire_strength = $FireStrength;
@onready var fire_interactable = $FireInteractableNotice;

func _ready():
	update_wood_pieces(0);
	update_fire_strength(1);

func update_wood_pieces(pieces: int):
	wood_pieces.text = str(pieces);
	
func update_fire_strength(strength):
	fire_strength.value = strength;

func update_fire_interactable(status: bool, wood_to_deposit: int):
	if status:
		var end: String;
		if wood_to_deposit == 1:
			end = " wood piece";
		else:
			end = " wood pieces";

		fire_interactable.text = "Press E to burn " + str(wood_to_deposit) + end;
	else:
		fire_interactable.text = "";
