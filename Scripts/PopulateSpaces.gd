extends Node3D

var space_instance = preload("res://Assets/Space.tscn")
var piece_instance = preload("res://Assets/Piece.tscn")
var pieces_array = []
var _temp_pos_grid = []
var row_lengths = [1, 2, 3, 4, 13, 12, 11, 10, 9, 10, 11, 12, 13, 4, 3, 2, 1]


#rows are 1, 2, 3, 4, 13, 12, 11, 10, 9, 10, 11, 12, 13, 4, 3, 2, 1
# Called when the node enters the scene tree for the first time.
func _ready():
	#create_rows()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func populate_space_neighbors():
	#top left, top right, left, right, bot left, bot right
	var neighbor_grid_base = [false, false, false, false, false, false]
	#rules - if at top (i is 0), cannot have top neighbors
	#if at bottom ( i is len-1), cannot have bottom neighbors
	#if on left edge (j is 0), cannot have left neighbors
	#if on right edge (j is len-1) cannot have right neighbors
	#if on CORNER (4 pieces where they are the 13 piece row, they will not have a second piece above/below them)
	#otherwise, spaces should have neighbors. If a space has a neighbor, both spaces should add each other as neighbors
	for i in len(pieces_array):
		for j in len(pieces_array[i]):
			#top
			valid_top_neighbors(i, j)
			#left
			valid_left_neighbors(i, j)
			#right
			valid_right_neighbors(i, j)
			#bottom
			valid_bottom_neighbors(i, j)
	pass

func valid_top_left_neighbors(i,j):
	if i == 0:
		return
	elif i <= 3 and j == 0:
		return
	elif i > 8 and i <= 12 and j == 0:
		return
	elif i == 4 and (j <= 4 or j > 8):
		return
	elif i == 4 and j >= 5 and j <= 8:
		pieces_array[i][j].neighbors.append(pieces_array[i-1][j-5])
	elif i == 13:
		pieces_array[i][j].neighbors.append(pieces_array[i-1][j+4])
	elif (i >= 9 and i <= 12 and j != 0) or (i >= 1 and i <= 3 and j != 0):
		pieces_array[i][j].neighbors.append(pieces_array[i-1][j-1])
	else:
		pieces_array[i][j].neighbors.append(pieces_array[i-1][j])
	pass
	
func valid_top_right_neighbors(i,j):
	if i == 0:
		return
	elif i <= 3 and j == len(pieces_array[i])-1:
		return
	elif i > 8 and i <= 12 and j == len(pieces_array[i])-1:
		return
	elif i == 4 and (j < 4 or j >= 8):
		return
	elif i == 4 and j >= 4 and j < 8:
		pieces_array[i][j].neighbors.append(pieces_array[i-1][j-4])
	elif i == 13:
		pieces_array[i][j].neighbors.append(pieces_array[i-1][j+5])
	elif (i >= 9 and i <= 12 and j != len(pieces_array[i])-1) or (i >= 1 and i <= 3 and j != len(pieces_array[i])-1):
		pieces_array[i][j].neighbors.append(pieces_array[i-1][j])
	else:
		pieces_array[i][j].neighbors.append(pieces_array[i-1][j+1])
	pass

func valid_top_neighbors(i, j):
	valid_top_left_neighbors(i, j)
	valid_top_right_neighbors(i, j)
	pass
	
func valid_left_neighbors(i, j):
	if j == 0:
		#print("no left")
		return
	else:
		#print("left")
		pieces_array[i][j].neighbors.append(pieces_array[i][j-1])
	return
	
func valid_right_neighbors(i, j):
	if j == len(pieces_array[i])-1:
		#print("no right")
		return
	else:
		#print("right")
		pieces_array[i][j].neighbors.append(pieces_array[i][j+1])
	return

func valid_bottom_left_neighbors(i,j):
	if i == 16:
		return
	elif i >= 13 and j == 0:
		return
	elif i >= 4 and i < 8 and j == 0:
		return
	elif i == 12 and (j <= 4 or j > 8):
		return
	elif i == 12 and j >= 5 and j <= 8:
		pieces_array[i][j].neighbors.append(pieces_array[i+1][j-5])
	elif i == 3:
		pieces_array[i][j].neighbors.append(pieces_array[i+1][j+4])
	elif (i >= 4 and i <= 7 and j != 0) or (i >= 13 and i <= 16 and j != 0):
		pieces_array[i][j].neighbors.append(pieces_array[i+1][j-1])
	else:
		pieces_array[i][j].neighbors.append(pieces_array[i+1][j])
	pass
	
func valid_bottom_right_neighbors(i,j):
	if i == 16:
		return
	elif i >= 13 and j == len(pieces_array[i])-1:
		return
	elif i >= 4 and i < 8 and j == len(pieces_array[i])-1:
		return
	elif i == 12 and (j < 4 or j >= 8):
		return
	elif i == 12 and j >= 4 and j <= 7:
		pieces_array[i][j].neighbors.append(pieces_array[i+1][j-4])
	elif i == 3:
		pieces_array[i][j].neighbors.append(pieces_array[i+1][j+5])
	elif (i >= 4 and i <= 7 and j != len(pieces_array[i])-1) or (i >= 13 and i <= 16 and j != len(pieces_array[i])-1):
		pieces_array[i][j].neighbors.append(pieces_array[i+1][j])
	else:
		pieces_array[i][j].neighbors.append(pieces_array[i+1][j+1])
	pass
	
func valid_bottom_neighbors(i, j):
	valid_bottom_left_neighbors(i, j)
	valid_bottom_right_neighbors(i, j)
	pass

func name_spaces(i:int, j:int):
	var classification = ""
	match i:
		1:
			classification = "Starting Spot 1 1"
		2:
			classification = "Starting Spot 1"
			match j:
				0:
					classification += " 2"
				1:
					classification += " 3"
		3:
			classification = "Starting Spot 1"
			match j:
				0:
					classification += " 4"
				1:
					classification += " 5"
				2:
					classification += " 6"
		4:
			classification = "Starting Spot 1"
			match j:
				0:
					classification += " 7"
				1:
					classification += " 8"
				2:
					classification += " 9"
				3:
					classification += " 10"
		-1:
			classification = "Starting Spot 2 1"
		-2:
			classification = "Starting Spot 2"
			match j:
				0:
					classification += " 2"
				1:
					classification += " 3"
		-3:
			classification = "Starting Spot 2"
			match j:
				0:
					classification += " 4"
				1:
					classification += " 5"
				2:
					classification += " 6"
		-4:
			classification = "Starting Spot 2"
			match j:
				0:
					classification += " 7"
				1:
					classification += " 8"
				2:
					classification += " 9"
				3:
					classification += " 10"
		13:
			match j:
				0:
					classification += "Starting Spot 3 1"
				1:
					classification += "Starting Spot 3 3"
				2:
					classification += "Starting Spot 3 6"
				3:
					classification += "Starting Spot 3 10"
				9:
					classification += "Starting Spot 6 7"
				10:
					classification += "Starting Spot 6 4"
				11:
					classification += "Starting Spot 6 2"
				12:
					classification += "Starting Spot 6 1"
				_:
					classification = "Neutral Space"
		-13:
			match j:
				0:
					classification += "Starting Spot 5 1"
				1:
					classification += "Starting Spot 5 3"
				2:
					classification += "Starting Spot 5 6"
				3:
					classification += "Starting Spot 5 10"
				9:
					classification += "Starting Spot 4 7"
				10:
					classification += "Starting Spot 4 4"
				11:
					classification += "Starting Spot 4 2"
				12:
					classification += "Starting Spot 4 1"
				_:
					classification = "Neutral Space"
		12:
			match j:
				0:
					classification += "Starting Spot 3 2"
				1:
					classification += "Starting Spot 3 5"
				2:
					classification += "Starting Spot 3 9"
				9:
					classification += "Starting Spot 6 8"
				10:
					classification += "Starting Spot 6 5"
				11:
					classification += "Starting Spot 6 3"
				_:
					classification = "Neutral Space"
		-12:
			match j:
				0:
					classification += "Starting Spot 5 2"
				1:
					classification += "Starting Spot 5 5"
				2:
					classification += "Starting Spot 5 9"
				9:
					classification += "Starting Spot 4 8"
				10:
					classification += "Starting Spot 4 5"
				11:
					classification += "Starting Spot 4 3"
				_:
					classification = "Neutral Space"
		11:
			match j:
				0:
					classification += "Starting Spot 3 4"
				1:
					classification += "Starting Spot 3 8"
				9:
					classification += "Starting Spot 6 9"
				10:
					classification += "Starting Spot 6 6"
				_:
					classification = "Neutral Space"
		-11:
			match j:
				0:
					classification += "Starting Spot 5 4"
				1:
					classification += "Starting Spot 5 8"
				9:
					classification += "Starting Spot 4 9"
				10:
					classification += "Starting Spot 4 6"
				_:
					classification = "Neutral Space"
		10:
			match j:
				0:
					classification += "Starting Spot 3 7"
				9:
					classification += "Starting Spot 6 10"
				_:
					classification = "Neutral Space"
		-10:
			match j:
				0:
					classification += "Starting Spot 5 7"
				9:
					classification += "Starting Spot 4 10"
				_:
					classification = "Neutral Space"
		_:
			classification = "Neutral Space"
	return classification
	
func create_rows():
	var counter = 0
	var flip = false
	for i in row_lengths:
		var pieces_row = []
		for j in i:
			var space = space_instance.instantiate()
			var new_name = name_spaces(i, j) if flip == false else name_spaces(-i, j)
			space.name = new_name + " " + str(counter) if new_name == "Neutral Space" else new_name
			counter = counter + 1 if new_name == "Neutral Space" else counter
			if i == 9 and j == 4:
				space.name = "Center Space"
				flip = true
			pieces_row.append(space)
		pieces_array.append(pieces_row)
	apply_piece_grid()
	pass
	
func apply_piece_grid():
	print("here")
	assign_proper_grid_space()
	print("finished")
	for i in len(pieces_array):
		for j in len(pieces_array[i]):
			add_child(pieces_array[i][j])
			pieces_array[i][j].position = _temp_pos_grid[i][j]
	populate_space_neighbors()
	pass

func assign_proper_grid_space():
	#Going in the order of middle row, closest bottom, closest top
	var counter = false
	var xp
	var zp
	for i in row_lengths:
		var pieces_row = []
		if i == 9:
			counter = !counter
		var row_pos = []
		var start_point = measurements_for_grid(i) if counter == true else measurements_for_grid(-i)
		xp = start_point[0]
		zp = start_point[1]
		for j in i:
			row_pos.append(Vector3(xp, 0, zp))
			xp = xp + 2 if j != i else xp
		_temp_pos_grid.append(row_pos)
	
func measurements_for_grid(row:int):
	var xpos
	var zpos
	match row:
		1:
			xpos = 0
			zpos = 16
		-1:
			xpos = 0
			zpos = -16
		2:
			xpos = -1
			zpos = 14
		-2:
			xpos = -1
			zpos = -14
		3:
			xpos = -2
			zpos = 12
		-3:
			xpos = -2
			zpos = -12
		4:
			xpos = -3
			zpos = 10
		-4:
			xpos = -3
			zpos = -10
		13:
			xpos = -12
			zpos = 8
		-13:
			xpos = -12
			zpos = -8
		12:
			xpos = -11
			zpos = 6
		-12:
			xpos = -11
			zpos = -6
		11:
			xpos = -10
			zpos = 4
		-11:
			xpos = -10
			zpos = -4
		10:
			xpos = -9
			zpos = 2
		-10:
			xpos = -9
			zpos = -2
		9:
			xpos = -8
			zpos = 0
		_:
			xpos = 0
			zpos = 0
	return([xpos, zpos])
	
func identify_neighbor_space():
	#Figures out which spaces are neighboring
	pass

