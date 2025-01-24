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
	if num_players == 0:
		num_players = 2
	create_players()
	choose_turn_order()
	start_game()
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
	var check = player_order.find(moving_player)
	if check < player_order.size() - 1:
		moving_player = player_order[check+1]
	else:
		moving_player = player_order[0]


func test_game():
	pass
	
func start_game():
	for spaces in pieces_array:
		for space in spaces:
			space.check_has_piece()
	turn()
	pass

func turn():
	print(moving_player)
	#Should be wincon check here

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


func create_pieces(player):
	var player_piece_array = []
	propogate_spaces(player)
	for i in starting_points:
		if str(player.number) in str(i.name).substr(0, 15):
			var new_piece = piece_instance.instantiate()
			i.add_child(new_piece)
			new_piece.name += " " + player.name + " " + str(i.name).substr(16)
			player_piece_array.append(new_piece)
			new_piece.global_position = i.global_position
			new_piece.global_position.y += 1.5
			new_piece.piece_identity(player, player.piece_mat)
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
	if selected_piece == null:
		piece.select_piece()
		selected_piece = piece
		piece.space_parent.select_space()
		if selected_space == null:
			selected_space = piece.space_parent
		else:
			selected_space.select_space()
			selected_space = piece.space_parent
	elif selected_piece != null and piece != selected_piece:
		piece.select_piece()
		selected_piece.select_piece()
		selected_piece = piece
		selected_space.select_space()
		#check here for errors
		piece.space_parent.select_space()
		selected_piece = piece
	elif selected_piece == piece:
		piece.select_piece()
		selected_piece == null
		piece.space_parent.select_space()
		selected_space = null
	pass
	
func select_player_space(is_filled, space):
	if selected_space == null and is_filled != true:
		space.select_space()
		selected_space = space
	elif selected_space != null and is_filled != true:
		selected_space.select_space()
		space.select_space()
		selected_space = space
	elif selected_space == space:
		space.select_space()
		selected_space = null
	else:
		print("Not a valid click")
	if selected_piece != null:
		selected_piece.select_piece()
		selected_piece = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
