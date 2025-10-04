extends Node

signal player_hit(damage: float, player_id: int)
signal player_died(player_id: int)

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
	for player:CharacterBody2D in get_children():
		if player.player_id == player_hit_id:
			player.health -= damage
			if player.health <= 0:
				player.health = 100
				player.stocks -= 1
				player_died.emit(player_hit_id)
				if player.stocks <= 0:
					player.queue_free()
				else:
					player.get_node("CollisionShape2D").disabled = true
					player.visible = false
					await get_tree().create_timer(3).timeout
					player.global_position = Vector2(0,0)
					player.get_node("CollisionShape2D").disabled = false
					player.visible = true
			else:
				player_hit.emit(damage, player_hit_id)
