extends Node

func _ready() -> void:
	await MultiplayerManager.game_start
	if multiplayer.is_server():
		await $"..".player_insantiated
		await $"..".player_insantiated
	else:
		await $"../PlayerSpawner".spawned
		await $"../PlayerSpawner".spawned
	
	for player in get_children():
		player.get_node("MoveResolver").move_instantiated.connect(_on_player_move_instantiated)

func _on_player_move_instantiated(player_hit_id: int, damage: float):
	damage_player.rpc(player_hit_id, damage)

@rpc("any_peer", "call_local")
func damage_player(player_hit_id: int, damage: float):
	for player in get_children():
		if player.player_id == player_hit_id:
			player.health -= damage
