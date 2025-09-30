extends Node

var server_connector := preload("res://scenes/ui/server_connector.tscn")
var stage_selector := preload("res://scenes/ui/stage_selector.tscn")
var waiting_screen := preload("res://scenes/ui/waiting_screen.tscn")

var stage_scenes: Array[PackedScene] = [
	preload("res://scenes/stages/ninja_gardens.tscn"),
	preload("res://scenes/stages/big_hands_city.tscn")
]

var ninja := preload("res://scenes/characters/ninja.tscn")

var ready_for_stage := false
const SERVER := 1

enum stages {
	NINJA_GARDENS,
	BIG_HANDS_CITY
}

var player_names = {}

# will stay as -1 on the client
var selected_stage := -1

var host_game: Button
var join_game: Button
var ip_address_field: LineEdit
var name_field: LineEdit

func _ready() -> void:
	add_child(server_connector.instantiate())
	host_game = $ServerConnector.get_node("%HostGame")
	join_game = $ServerConnector.get_node("%JoinGame")
	ip_address_field = $ServerConnector.get_node("%IPAddressField")
	name_field = $ServerConnector.get_node("%NameField")
	host_game.pressed.connect(_on_host_game_pressed)
	join_game.pressed.connect(_on_join_game_pressed)
	name_field.text_submitted.connect(_on_name_field_text_submitted)

func _on_name_field_text_submitted(new_text: String):
	if new_text != "":
		host_game.disabled = false
		join_game.disabled = false
	else:
		host_game.disabled = true
		join_game.disabled = true

func _on_host_game_pressed():
	$ServerConnector.queue_free()
	select_stage()
	MultiplayerManager.become_host()

func _on_join_game_pressed():
	$ServerConnector.queue_free()
	sync_stages()
	if ip_address_field.has_ime_text():
		MultiplayerManager.join_as_player_2(ip_address_field.text)
	else:
		MultiplayerManager.join_as_player_2(ip_address_field.placeholder_text)

func select_stage():
	add_child(stage_selector.instantiate())
	$StageSelector.get_node("%NinjaGardensButton").pressed.connect(_on_ninja_gardens_button_pressed)
	$StageSelector.get_node("%BigHandsCityButton").pressed.connect(_on_big_hands_city_button_pressed)

#func select_character():
	#add_child(character_selector.instantiate())
	#$CharacterSelector/CenterContainer/HBoxContainer/CenterContainer/VBoxContainer/NinjaButton.pressed.connect(_on_ninja_button_pressed)
	#$CharacterSelector/CenterContainer/HBoxContainer/CenterContainer2/VBoxContainer/CowboyButton.pressed.connect(_on_cowboy_button_pressed)

func _on_ninja_gardens_button_pressed():
	selected_stage = stages.NINJA_GARDENS
	$StageSelector.queue_free()
	sync_stages()

func _on_big_hands_city_button_pressed():
	selected_stage = stages.BIG_HANDS_CITY
	$StageSelector.queue_free()
	sync_stages()

#func _on_ninja_button_pressed():
	#selected_character = characters.NINJA
	#$CharacterSelector.queue_free()
	#sync_stages()

#func _on_cowboy_button_pressed():
	#selected_character = characters.COWBOY
	#$CharacterSelector.queue_free()
	#sync_stages()

func sync_stages():
	add_child(waiting_screen.instantiate())
	ready_for_stage = true
	if not multiplayer.get_peers().is_empty():
		attempt_to_instantiate_stage.rpc_id(multiplayer.get_peers()[0])
	else:
		await multiplayer.peer_connected
		attempt_to_instantiate_stage.rpc_id(multiplayer.get_peers()[0])

# called with context that the other peer is ready for the stage
@rpc("any_peer", "call_local")
func attempt_to_instantiate_stage():
	if ready_for_stage:
		call_instantiate_stage.rpc_id(SERVER)

# used to call instantiate_stage because it needs to be done on the server so it can access the selected stage
@rpc("any_peer", "call_local")
func call_instantiate_stage():
	instantiate_stage.rpc(selected_stage)

@rpc("authority", "call_local")
func instantiate_stage(stage: int):
	if $WaitingScreen != null:
		$WaitingScreen.queue_free()
	add_child(stage_scenes[stage].instantiate())
	instantiate_player.rpc_id(SERVER)

@rpc("any_peer", "call_local")
func instantiate_player():
	var player_to_instantiate := ninja.instantiate()
	player_to_instantiate.name = str(multiplayer.get_remote_sender_id())
	$PlayerResolver.add_child(player_to_instantiate, true)
