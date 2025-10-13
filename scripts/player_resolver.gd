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

func _on_player_move_instantiated(player_hit_id: int, damage: float, knockback: Vector2):
	hit_player.rpc(player_hit_id, damage, knockback)

@rpc("any_peer", "call_local")
func hit_player(player_hit_id: int, damage: float, knockback: Vector2):
	var player_hit_char: CharacterBody2D
	var player_attacker: CharacterBody2D
	for player:CharacterBody2D in get_children():
		if player.player_id == player_hit_id:
			player_hit_char = player
		else:
			player_attacker = player
	damage_player(player_hit_char, damage)
	if multiplayer.get_unique_id() != multiplayer.get_remote_sender_id():
		print(multiplayer.get_unique_id())
		knockback_player(player_hit_char, player_attacker, knockback)

func damage_player(player:CharacterBody2D, damage: float):
	player.health -= damage
	if player.health <= 0:
		player.health = 100
		player.stocks -= 1
		player_died.emit(player.player_id)
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
		player_hit.emit(damage, player.player_id)

func knockback_player(player_hit_char:CharacterBody2D, player_attacker: CharacterBody2D, knockback: Vector2):
	print(player_attacker.fliped)
	print(knockback)
	if player_attacker.fliped:
		player_hit_char.velocity = knockback
		print("1 ",player_hit_char.velocity)
	else:
		player_hit_char.velocity = Vector2(-knockback.x,knockback.y)
		print("2 ",player_hit_char.velocity)
