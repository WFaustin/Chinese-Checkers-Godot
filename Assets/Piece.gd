class_name Piece
extends MeshInstance3D

var player
var mat
var head
var highlight = preload("res://Assets/Materials/HighlightPiece.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	head = get_node("Piece_Head")
	pass # Replace with function body.

func piece_identity(_player, _mat) -> Piece:
	self.player = _player
	self.mat = _mat
	self.mesh.surface_set_material(0, _mat)
	get_node("Piece_Head").mesh.surface_set_material(0, _mat)
	print(self.name + " has the following player: " + self.player.name + " and the following material: " + str(self.mat.albedo_color) + " .")
	return self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_static_body_3d_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and !event.is_released():
			print(self.name + " has been clicked")
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
			print(self.name + " has been released")
	pass # Replace with function body.

func toggle_highlight(_on):
	if _on == true:
		self.mesh.surface_set_material(0, highlight)
		get_node("Piece_Head").mesh.surface_set_material(0, highlight)
	else:
		self.mesh.surface_set_material(0, mat)
		get_node("Piece_Head").mesh.surface_set_material(0, mat)

func _on_static_body_3d_mouse_entered():
	toggle_highlight(true)
	pass # Replace with function body.


func _on_static_body_3d_mouse_exited():
	toggle_highlight(false)
	pass # Replace with function body.
