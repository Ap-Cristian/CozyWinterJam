extends CanvasLayer

@onready var wood_pieces = $WoodPieces;

func update_wood_pieces(pieces: int):
	wood_pieces.text = str(pieces);
