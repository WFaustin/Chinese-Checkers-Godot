extends MeshInstance3D
var basemat = preload("res://Assets/Materials/BaseSpaceMat.tres")
var hovermat = preload("res://Assets/Materials/HoverSpaceMat.tres")
var selectedmat = preload("res://Assets/Materials/SelectedSpaceMat.tres")
var filledmat = preload("res://Assets/Materials/FilledSpaceMat.tres")
var piece = preload("res://Assets/Piece.tscn")
signal ClickSignal(space_filled: bool, space_obj)
@export var toggle_on_hover: Color
var original_color = mesh.surface_get_material(0).albedo_color
@export var is_filled : bool = false
@export var is_selected : bool = false
@export var occupying_piece : Node
@export var neighbors = []
var bottom_left_neighbor = null
var bottom_right_neighbor = null
var top_left_neighbor = null
var top_right_neighbor = null
var left_neighbor = null
var right_neighbor = null



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#check_has_piece()
	pass


func check_has_piece():
	if get_child_count() > 1 and "Piece" in get_children()[1].name:
		is_filled = true
		occupying_piece = get_children()[1]
		self.mesh.surface_set_material(0, filledmat)
	else:
		is_filled = false
		occupying_piece = null
		self.mesh.surface_set_material(0, basemat)
	pass


func get_top_left_neighbor():
	return top_left_neighbor
	
func get_top_right_neighbor():
	return top_right_neighbor

func get_left_neighbor():
	return left_neighbor
	
func get_right_neighbor():
	return right_neighbor

func get_bottom_left_neighbor():
	return bottom_left_neighbor
	
func get_bottom_right_neighbor():
	return bottom_right_neighbor

func _on_static_body_3d_mouse_entered():
	if !is_selected:
		print(self.name)
		self.mesh.surface_set_material(0, hovermat)
	pass # Replace with function body.

func select_space():
	#checks if false or true first, then changes the value to what it should be.
	if !is_selected:
		self.mesh.surface_set_material(0, selectedmat)
		#occupying_piece = piece.instantiate()
		#add_child(occupying_piece)
		#print(occupying_piece)
		#occupying_piece.global_position = self.global_position
		#occupying_piece.position.y += 1.5
		#occupying_piece.position.y += 3
		print(self.position)
		#print(occupying_piece.position)
	else:
		if is_filled:
			self.mesh.surface_set_material(0, filledmat)
		else:
			self.mesh.surface_set_material(0, basemat)
		#if occupying_piece != null:
		#	occupying_piece.queue_free()
	is_selected = !is_selected
	check_has_piece()
	print(neighbors)
		

func _on_static_body_3d_mouse_exited():
	if !is_selected:
		check_has_piece()
		#self.mesh.surface_get_material(0).albedo_color = original_color
	pass # Replace with function body.


func _on_static_body_3d_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and !event.is_released():
			print(self.name + " has been clicked")
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
			print(self.name + " has been released")
			ClickSignal.emit(is_selected, self)
			#select_space()
	pass # Replace with function body.


