extends Node

var server_connector := preload("res://scenes/server_connector.tscn")
var stage_selector := preload("res://scenes/stage_selector.tscn")
var character_selector := preload("res://scenes/character_selector.tscn")

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

var selected_character: int
var selected_stage: int

func _ready() -> void:
	add_child(server_connector.instantiate())
	$ServerConnector/CenterContainer/VBoxContainer/HostGame.pressed.connect(_on_host_game_pressed)
	$ServerConnector/CenterContainer/VBoxContainer/JoinGame.pressed.connect(_on_join_game_pressed)

func _on_host_game_pressed():
	$ServerConnector.queue_free()
	select_stage()

func _on_join_game_pressed():
	$ServerConnector.queue_free()
	select_character()

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

func _on_cowboy_button_pressed():
	selected_character = characters.COWBOY
	$CharacterSelector.queue_free()

func _on_big_hands_button_pressed():
	selected_character = characters.BIG_HANDS
	$CharacterSelector.queue_free()
