class_name Player
extends Node3D

var id : int
@export var number : int
@export var piece_mat : Material
var player_pieces = []


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func random_id():
	pass

func player_info_instantiation(number, id, piece_mat) -> Player:
	self.id = id
	self.number = number
	self.piece_mat = piece_mat
	self.name = "Player " + str(number)
	return self
	
func set_pieces(pieces):
	player_pieces = pieces
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
