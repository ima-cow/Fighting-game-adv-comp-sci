extends Node

signal player_insantiated

var server_connector := preload("res://scenes/ui/server_connector.tscn")
var stage_selector := preload("res://scenes/ui/stage_selector.tscn")
var waiting_screen := preload("res://scenes/ui/waiting_screen.tscn")

var stage_scenes: Array[PackedScene] = [
	preload("res://scenes/stages/ninja_gardens.tscn")
]

var ninja := preload("res://scenes/characters/ninja.tscn")

var ready_for_stage := false
const SERVER := 1

enum stages {
	NINJA_GARDENS
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
	
	$PlayerResolver.player_died.connect(_on_player_died)
	$PlayerResolver.player_hit.connect(_on_player_hit)

func _on_name_field_text_submitted(new_text: String):
	if new_text != "":
		host_game.disabled = false
		join_game.disabled = false
	else:
		host_game.disabled = true
		join_game.disabled = true

func _on_host_game_pressed():
	$ServerConnector.queue_free()
	add_name.rpc(name_field.text)
	select_stage()
	MultiplayerManager.become_host()

func _on_join_game_pressed():
	if ip_address_field.has_ime_text():
		MultiplayerManager.join_as_player_2(ip_address_field.text)
		await multiplayer.connected_to_server
		add_name.rpc(name_field.text)
	else:
		MultiplayerManager.join_as_player_2(ip_address_field.placeholder_text)
		await multiplayer.connected_to_server
		add_name.rpc(name_field.text)
	$ServerConnector.queue_free()
	sync_stages()

@rpc("any_peer", "call_local")
func add_name(name_to_add: String):
	player_names[multiplayer.get_remote_sender_id()] = name_to_add

func select_stage():
	add_child(stage_selector.instantiate())
	$StageSelector.get_node("%NinjaGardensButton").pressed.connect(_on_ninja_gardens_button_pressed)
func _on_ninja_gardens_button_pressed():
	selected_stage = stages.NINJA_GARDENS
	$StageSelector.queue_free()
	sync_stages()

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
	player_insantiated.emit()

func _on_player_hit(damage: float, player_id: int):
	var server_hud := get_child(2).get_node("ServerHUD")
	var client_hud := get_child(2).get_node("ClientHUD")
	if player_id == SERVER:
		server_hud.get_node("%HealthBar").value -= damage
	else:
		client_hud.get_node("%HealthBar").value -= damage

func _on_player_died(player_id: int):
	var server_hud := get_child(2).get_node("ServerHUD")
	var client_hud := get_child(2).get_node("ClientHUD")
	if player_id == SERVER:
		server_hud.get_node("%StocksBar").value -= 1
		server_hud.get_node("%HealthBar").value = 100.0
	else:
		client_hud.get_node("%StocksBar").value -= 1
		client_hud.get_node("%HealthBar").value = 100.0
