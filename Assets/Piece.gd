class_name Piece
extends MeshInstance3D

var player
var mat

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func piece_identity(_player, _mat) -> Piece:
	self.player = _player
	self.mat = _mat
	self.mesh.surface_set_material(0, mat)
	get_node("Piece_Head").mesh.surface_set_material(0, mat)
	return self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
