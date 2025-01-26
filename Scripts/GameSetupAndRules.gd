extends Node3D
@export var num_players: int
var players = []
var starting_points = []
var game_over = false
var turn_over = false
var can_move = false
var moving_player
var spaces_ref
var pieces_array = []
var player_order = []
var selected_piece
var selected_space
var jump_history = []
var player_instance = preload("res://Assets/Player.tscn")
var piece_instance = preload("res://Assets/Piece.tscn")
var rng = RandomNumberGenerator.new()


#var def_space = preload("res://Assets/Space.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	spaces_ref = self.get_children()[0].get_children()[0]
	spaces_ref.create_rows()
	pieces_array = spaces_ref.pieces_array
	connect_click_signal()
	if num_players < 3:
		num_players = 6
	create_players()
	choose_turn_order()
	create_goal_spaces()
	start_game()
	#test_game()
	pass # Replace with function body.

func connect_click_signal():
	for spaces in pieces_array:
		for space in spaces:
			space.connect("ClickSignal", select_player_space)
			
			
func connect_click_signal_piece(piece):
	piece.connect("ClickSignal", select_player_piece)
	pass

func choose_turn_order():
	var rng = RandomNumberGenerator.new()
	var dup_players = players.duplicate()
	while dup_players.size() > 0:
		var chosen_player_num = rng.randi_range(0, dup_players.size()-1)
		player_order.append(dup_players[chosen_player_num])
		dup_players.pop_at(chosen_player_num)
	moving_player = player_order[0]
		
func cycle_players():
	check_win()
	var check = player_order.find(moving_player)
	if check < player_order.size() - 1:
		moving_player = player_order[check+1]
	else:
		moving_player = player_order[0]
	turn()


func test_game():
	if players.size() > 2:
		for i in range(0, players[2].goal_points.size()):
			#Remove piece from space
			players[2].player_pieces[i].space_parent.remove_child(players[2].player_pieces[i])
			#Check original space parent to make sure the piece is gone
			players[2].player_pieces[i].space_parent.check_has_piece()
			#Unhook the space_parent from the piece
			players[2].player_pieces[i].space_parent = null
			#Get the goal space from the loop and add the piece to it. 
			players[2].goal_points[i].add_child(players[2].player_pieces[i])
			players[2].player_pieces[i].space_parent = players[2].goal_points[i]
			players[2].player_pieces[i].space_parent.check_has_piece()
			players[2].player_pieces[i].global_position = players[2].player_pieces[i].space_parent.global_position
			players[2].player_pieces[i].global_position.y += 1.5
	pass
	
func start_game():
	for spaces in pieces_array:
		for space in spaces:
			space.check_has_piece()
	turn()
	pass

func turn():
	print(moving_player.name + "'s turn!")

		
	#Should be wincon check here

#Do check win check at later point
func check_win():
	for i in moving_player.goal_points:
		if !i.is_filled:
			return false
		elif i.occupying_piece.player != moving_player:
			return false
	print(moving_player.name + " wins!")
	return true

func create_players():
	for num in range(0, num_players):
		var new_player = player_instance.instantiate()
		var id = rng.randi_range(1000, 99999)
		var number = num + 1
		var mat = choose_mat_for_player(number)
		new_player.player_info_instantiation(number, id, mat)
		players.append(new_player)
		get_node("PlayerNodeHolder").add_child(new_player)
		create_pieces(new_player)
	#for i in players:
		#create_pieces(i)

func create_goal_spaces():
	if players.size() % 2 == 0:
		print("even")
		for i in range(0, players.size(), 2):
			players[i].goal_points = players[i+1].starting_points
			players[i+1].goal_points = players[i].starting_points
	else:
		for i in range(0, players.size()-1, 2):
			players[i].goal_points = players[i+1].starting_points
			players[i+1].goal_points = players[i].starting_points
		var searchword = "Starting Spot"
		for i in pieces_array:
			for j in i:
				if searchword + " " + str(players[players.size()-1].number + 1) in j.name:
					players[players.size()-1].goal_points.append(j)
		print("odd")

func create_pieces(player):
	var player_piece_array = []
	propogate_spaces(player)
	for i in starting_points:
		if str(player.number) in str(i.name).substr(0, 15):
			player.starting_points.append(i)
			var new_piece = piece_instance.instantiate()
			i.add_child(new_piece)
			new_piece.name += " " + player.name + " " + str(i.name).substr(16)
			player_piece_array.append(new_piece)
			new_piece.global_position = i.global_position
			new_piece.global_position.y += 1.5
			new_piece.piece_identity(player, player.piece_mat)
			i.occupying_piece = new_piece
			connect_click_signal_piece(new_piece)
	player.set_pieces(player_piece_array)
	#FIX PIECES NOT SHOWING UP WITH RIGHT MATERIAL
	pass	
	
func choose_mat_for_player(num):
	match num:
		1:
			return preload("res://Assets/Materials/Player1Mat.tres")
		2:
			return preload("res://Assets/Materials/Player2Mat.tres")
		3:
			return preload("res://Assets/Materials/Player3Mat.tres")
		4:
			return preload("res://Assets/Materials/Player4Mat.tres")
		5:
			return preload("res://Assets/Materials/Player5Mat.tres")
		6:
			return preload("res://Assets/Materials/Player6Mat.tres")
		-1:
			return null
	pass
	
	
func propogate_spaces(player):
	var searchword = "Starting Spot"
	#var player = 1
	var counter = 0
	var specific_start = []
	for i in pieces_array:
		for j in i:
			if searchword + " " + str(player.number) in j.name:
				starting_points.append(j)
				counter += 1
			if counter == 10:
				counter = 0
				break
	pass


func select_player_piece(piece):
	if piece.player == moving_player:
		if selected_piece == null:
			piece.select_piece()
			selected_piece = piece
			piece.space_parent.select_space()
			if selected_space == null:
				selected_space = piece.space_parent
			else:
				selected_space.select_space()
				selected_space = piece.space_parent
			print(piece.name + " has been selected.")
		elif selected_piece != null and piece != selected_piece:
			selected_piece.select_piece() 
			selected_space.select_space()
			print(piece.name + " has been selected. " + selected_piece.name + " has been deselected.")
			selected_piece = null
			selected_space = null
			piece.select_piece()
			selected_piece = piece
			piece.space_parent.select_space()
			selected_space = piece.space_parent
		elif selected_piece == piece:
			piece.select_piece()
			selected_piece = null
			piece.space_parent.select_space()
			selected_space = null
			print(piece.name + " has been deselected.")
	elif piece.player != moving_player:
		print("Please select one of your own pieces. That piece is a piece from: " + piece.player.name)
	pass

	
#func select_player_piece(piece): #Original function, does not intend to use move logic
#	if piece.player == moving_player:
#		if selected_piece == null:
#			piece.select_piece()
#			selected_piece = piece
#			#print(piece.name)
#			piece.space_parent.select_space()
#			#print(piece.space_parent.name)
#			if selected_space == null:
#				selected_space = piece.space_parent
#			else:
#				selected_space.select_space()
#				selected_space = piece.space_parent
#		elif selected_piece != null and piece != selected_piece:
#			selected_piece.select_piece()
#			selected_space.select_space()
#			selected_piece = null
#			selected_space = null
#			piece.select_piece()
#			selected_piece = piece
#			piece.space_parent.select_space()
#			selected_space = piece.space_parent
#		elif selected_piece == piece:
#			piece.select_piece()
#			selected_piece = null
#			piece.space_parent.select_space()
#			selected_space = null
#	elif piece.player != moving_player:
#		print("Please select one of your own pieces. That piece is a piece from: " + piece.player.name)
#	pass
	
	
func select_player_space(is_filled, space):
	if selected_piece != null:
		if is_filled != true:
			move_piece(space)
			print("Move Piece")
			return
		else:
			print("This space is filled currently. Please try again with another space.")
	else:
		if selected_space == null and is_filled != true:
			space.select_space()
			selected_space = space
			print(space.name + " has been selected.")
		elif selected_space != null and is_filled != true:
			selected_space.select_space()
			space.select_space()
			print(space.name + " has been selected. " + selected_space.name + " has been deselected.")
			selected_space = space
		elif selected_space == space:
			space.select_space()
			selected_space = null
			print(space.name + " has been deselected.")
		else:
			print("Not a valid click")
	#if selected_piece != null:
	#	selected_piece.select_piece()
	#	if selected_piece.space_parent.is_selected:
	#		selected_piece.space_parent.select_space()
	#	selected_piece = null


	
#func select_player_space(is_filled, space): #Original function, does not plan on using move_piece function
#	if selected_space == null and is_filled != true:
#		space.select_space()
#		selected_space = space
#	elif selected_space != null and is_filled != true:
#		selected_space.select_space()
#		space.select_space()
#		selected_space = space
#	elif selected_space == space:
#		space.select_space()
#		selected_space = null
#	else:
#		print("Not a valid click")
#	if selected_piece != null:
#		selected_piece.select_piece()
#		if selected_piece.space_parent.is_selected:
#			selected_piece.space_parent.select_space()
#		selected_piece = null


func deselect_all():
	if selected_piece != null:
		if selected_piece.is_selected:
			selected_piece.select_piece()
		if selected_piece.space_parent.is_selected:
			selected_piece.space_parent.select_space()
		selected_piece = null
	if selected_space != null:
		if selected_space.is_selected:
			selected_space.select_space()
		selected_space = null
	pass
	
	
func move_piece(space):
	#refactor select_piece and select_space along with sensing player turn to not highlight other piece players to use this. 
	jump_history = []
	if selected_piece.player == moving_player and space in selected_piece.space_parent.neighbors and !space.is_filled:
		selected_piece.space_parent.is_filled = false
		selected_piece.space_parent.remove_child(selected_piece)
		selected_piece.space_parent.select_space()
		selected_piece.space_parent = null
		selected_space = null
		space.add_child(selected_piece)
		selected_piece.global_position = space.global_position
		selected_piece.global_position.y += 1.5
		selected_piece.space_parent = space
		space.is_filled = true
		space.check_has_piece()
		if !check_win():
			cycle_players()
	elif selected_piece.player == moving_player and check_if_space_one_removed_proper(space) and !space.is_filled:
		print("HERE IS SKIPPING PIECES")
		selected_piece.space_parent.is_filled = false
		selected_piece.space_parent.remove_child(selected_piece)
		selected_piece.space_parent.select_space()
		selected_piece.space_parent = null
		selected_space = null
		space.add_child(selected_piece)
		selected_piece.global_position = space.global_position
		selected_piece.global_position.y += 1.5
		selected_piece.space_parent = space
		space.is_filled = true
		space.check_has_piece()
		if !check_win():
			cycle_players()
	else:
		print("Not a valid move, deselecting all pieces")
	deselect_all()
	pass

func check_if_space_one_removed_proper(space):
	var in_neighbors = false
	var correct_neighbor = null
	for i in selected_space.neighbors:
		if space in i.neighbors:
			in_neighbors = true
			correct_neighbor = i
	if !in_neighbors:
		return false
	else:
		if !correct_neighbor.is_filled:
			return false
		elif correct_neighbor.is_filled and selected_piece.space_parent.get_left_neighbor() == correct_neighbor and correct_neighbor.get_left_neighbor() == space:
			return true
		elif correct_neighbor.is_filled and selected_piece.space_parent.get_right_neighbor() == correct_neighbor and correct_neighbor.get_right_neighbor() == space:
			return true
		elif correct_neighbor.is_filled and selected_piece.space_parent.get_bottom_left_neighbor() == correct_neighbor and correct_neighbor.get_bottom_left_neighbor() == space:
			return true
		elif correct_neighbor.is_filled and selected_piece.space_parent.get_top_left_neighbor() == correct_neighbor and correct_neighbor.get_top_left_neighbor() == space:
			return true
		elif correct_neighbor.is_filled and selected_piece.space_parent.get_bottom_right_neighbor() == correct_neighbor and correct_neighbor.get_bottom_right_neighbor() == space:
			return true
		elif correct_neighbor.is_filled and selected_piece.space_parent.get_top_right_neighbor() == correct_neighbor and correct_neighbor.get_top_right_neighbor() == space:
			return true
		else:
			return false
	pass


func continued_jump_move():
	#for i in selected_piece.space_parent.neighbors:
	#	if i 
	pass

func find_other_non_dups_to_jump_to():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
