class_name Piece
extends MeshInstance3D

var player
var mat
var head
var filled = preload("res://Assets/Materials/BaseSpaceMat.tres")
var highlight = preload("res://Assets/Materials/HighlightPiece.tres")
var space_parent = null
@export var is_selected : bool = false
signal ClickSignal(space_obj)

# Called when the node enters the scene tree for the first time.
func _ready():
	head = get_node("Piece_Head")
	space_parent = get_parent()
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

func select_piece():
	if !is_selected:
		self.mesh.surface_set_material(0, filled)
		get_node("Piece_Head").mesh.surface_set_material(0, filled)
		#occupying_piece = piece.instantiate()
		#add_child(occupying_piece)
		#print(occupying_piece)
		#occupying_piece.global_position = self.global_position
		#occupying_piece.position.y += 1.5
		#occupying_piece.position.y += 3
		print(self.position)
		#print(occupying_piece.position)
	else:
		self.mesh.surface_set_material(0, mat)
		get_node("Piece_Head").mesh.surface_set_material(0, mat)
		#if occupying_piece != null:
		#	occupying_piece.queue_free()
	is_selected = !is_selected
	pass

func _on_static_body_3d_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and !event.is_released():
			print(self.name + " has been clicked")
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
			print(self.name + " has been released")
			ClickSignal.emit(self)
	pass # Replace with function body.

func toggle_highlight(_on):
	if _on == true:
		self.mesh.surface_set_material(0, highlight)
		get_node("Piece_Head").mesh.surface_set_material(0, highlight)
	else:
		self.mesh.surface_set_material(0, mat)
		get_node("Piece_Head").mesh.surface_set_material(0, mat)

func _on_static_body_3d_mouse_entered():
	if !is_selected:
		toggle_highlight(true)
		space_parent._on_static_body_3d_mouse_entered()
	pass # Replace with function body.


func _on_static_body_3d_mouse_exited():
	if !is_selected:
		toggle_highlight(false)
		space_parent._on_static_body_3d_mouse_exited()
	pass # Replace with function body.
