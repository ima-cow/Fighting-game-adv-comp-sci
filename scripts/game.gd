extends Node

var server_connector := preload("res://scenes/ui/server_connector.tscn")
var stage_selector := preload("res://scenes/ui/stage_selector.tscn")
var character_selector := preload("res://scenes/ui/character_selector.tscn")
var waiting_screen := preload("res://scenes/ui/waiting_screen.tscn")

var stage_scenes: Array[PackedScene] = [preload("res://scenes/stages/ninja_gardens.tscn"), preload("res://scenes/stages/cowboy_desert.tscn"), preload("res://scenes/stages/big_hands_city.tscn")]

var ready_for_stage := false

enum characters {
	NINJA,
	COWBOY,
	BIG_HANDS
}

enum stages {
	NINJA_GARDENS,
	COWBOW_DESERT,
	BIG_HANDS_CITY
}

var selected_character := -1
var selected_stage := -1

func _ready() -> void:
	add_child(server_connector.instantiate())
	$ServerConnector/CenterContainer/VBoxContainer/HostGame.pressed.connect(_on_host_game_pressed)
	$ServerConnector/CenterContainer/VBoxContainer/JoinGame.pressed.connect(_on_join_game_pressed)

func _on_host_game_pressed():
	$ServerConnector.queue_free()
	select_stage()
	MultiplayerManager.become_host()

func _on_join_game_pressed():
	$ServerConnector.queue_free()
	select_character()
	MultiplayerManager.join_as_player_2()

func select_stage():
	add_child(stage_selector.instantiate())
	$StageSelector/CenterContainer/HBoxContainer/CenterContainer/VBoxContainer/NinjaGardensButton.pressed.connect(_on_ninja_gardens_button_pressed)
	$StageSelector/CenterContainer/HBoxContainer/CenterContainer2/VBoxContainer/CowboyDesertButton.pressed.connect(_on_cowboy_desert_button_pressed)
	$StageSelector/CenterContainer/HBoxContainer/CenterContainer3/VBoxContainer/BigHandsCityButton.pressed.connect(_on_big_hands_city_button_pressed)

func select_character():
	add_child(character_selector.instantiate())
	$CharacterSelector/CenterContainer/HBoxContainer/CenterContainer/VBoxContainer/NinjaButton.pressed.connect(_on_ninja_button_pressed)
	$CharacterSelector/CenterContainer/HBoxContainer/CenterContainer2/VBoxContainer/CowboyButton.pressed.connect(_on_cowboy_button_pressed)
	$CharacterSelector/CenterContainer/HBoxContainer/CenterContainer3/VBoxContainer/BigHandsButton.pressed.connect(_on_big_hands_button_pressed)

func _on_ninja_gardens_button_pressed():
	selected_stage = stages.NINJA_GARDENS
	$StageSelector.queue_free()
	select_character()

func _on_cowboy_desert_button_pressed():
	selected_stage = stages.COWBOW_DESERT
	$StageSelector.queue_free()
	select_character()

func _on_big_hands_city_button_pressed():
	selected_stage = stages.BIG_HANDS_CITY
	$StageSelector.queue_free()
	select_character()

func _on_ninja_button_pressed():
	selected_character = characters.NINJA
	$CharacterSelector.queue_free()
	sync_stages()

func _on_cowboy_button_pressed():
	selected_character = characters.COWBOY
	$CharacterSelector.queue_free()
	sync_stages()

func _on_big_hands_button_pressed():
	selected_character = characters.BIG_HANDS
	$CharacterSelector.queue_free()
	sync_stages()

func sync_stages():
	add_child(waiting_screen.instantiate())
	ready_for_stage = true
	attempt_to_instantiate_stage.rpc_id(multiplayer.get_peers()[0])

@rpc("authority", "call_local")
func instantiate_stage():
	if $WaitingScreen != null:
		$WaitingScreen.queue_free()
	add_child(stage_scenes[selected_stage].instantiate())

@rpc("any_peer", "call_local")
func call_instantiate_stage():
	instantiate_stage.rpc()

@rpc("any_peer", "call_local")
func attempt_to_instantiate_stage():
	if ready_for_stage:
		call_instantiate_stage.rpc()
