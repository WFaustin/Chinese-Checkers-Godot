extends MeshInstance3D
var basemat = preload("res://Assets/Materials/BaseSpaceMat.tres")
var hovermat = preload("res://Assets/Materials/HoverSpaceMat.tres")
var selectedmat = preload("res://Assets/Materials/SelectedSpaceMat.tres")
var piece = preload("res://Assets/Piece.tscn")
signal ClickSignal(space_filled: bool, space_obj)
@export var toggle_on_hover: Color
var original_color = mesh.surface_get_material(0).albedo_color
@export var is_filled : bool = false
@export var occupying_piece : Node
@export var neighbors = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_static_body_3d_mouse_entered():
	if !is_filled:
		print(self.name)
		self.mesh.surface_set_material(0, hovermat)
	pass # Replace with function body.

func fill_space():
	if !is_filled:
		self.mesh.surface_set_material(0, selectedmat)
		occupying_piece = piece.instantiate()
		add_child(occupying_piece)
		print(occupying_piece)
		occupying_piece.global_position = self.global_position
		occupying_piece.position.y += 1.5
		print(self.position)
		print(occupying_piece.position)
	else:
		self.mesh.surface_set_material(0, basemat)
		if occupying_piece != null:
			occupying_piece.queue_free()
	is_filled = !is_filled
	print(neighbors)
		

func _on_static_body_3d_mouse_exited():
	if !is_filled:
		self.mesh.surface_set_material(0, basemat)
		#self.mesh.surface_get_material(0).albedo_color = original_color
	pass # Replace with function body.


func _on_static_body_3d_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and !event.is_released():
			print(self.name + " has been clicked")
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
			print(self.name + " has been released")
			ClickSignal.emit(is_filled, self)
			#fill_space()
	pass # Replace with function body.


