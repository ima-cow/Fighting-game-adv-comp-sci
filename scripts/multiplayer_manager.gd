extends Node

const SERVER_PORT := 8080
const SERVER_IP := "127.0.0.1"

func become_host():
	print("starting server")
	var server_peer := ENetMultiplayerPeer.new()
	server_peer.create_server(SERVER_PORT)
	
	multiplayer.multiplayer_peer = server_peer
	
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)

func join_as_player_2():
	print("starting client")
	var client_peer := ENetMultiplayerPeer.new()
	client_peer.create_client(SERVER_IP, SERVER_PORT)
	
	multiplayer.multiplayer_peer = client_peer

func _on_peer_connected(id: int):
	print("player %s has joined" % id)

func _on_peer_disconnected(id: int):
	print("player %s has left" % id)
	
