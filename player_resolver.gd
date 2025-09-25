extends Node

func _on_multiplayer_spawner_spawned(node: Node) -> void:
	node.player_id = node.name
