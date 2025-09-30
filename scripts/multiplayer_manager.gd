extends Node

const SERVER_PORT := 8080
signal game_start

func become_host():
	print("starting server")
	var server_peer := ENetMultiplayerPeer.new()
	server_peer.create_server(SERVER_PORT)
	
	multiplayer.multiplayer_peer = server_peer
	
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	
	game_start.emit()

func join_as_player_2(ip_address: String):
	print("starting client")
	var client_peer := ENetMultiplayerPeer.new()
	client_peer.create_client(ip_address, SERVER_PORT)
	multiplayer.multiplayer_peer = client_peer
	
	game_start.emit()

func _on_peer_connected(id: int):
	print("player %s has joined" % id)

func _on_peer_disconnected(id: int):
	print("player %s has left" % id)
	
