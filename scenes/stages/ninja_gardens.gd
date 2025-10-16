extends Node

func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	print(multiplayer.get_unique_id(),"  ",$"..".player_names)
	$ServerHUD.get_node("%NameLabel").text = "Name: "+$"..".player_names["server"]
	$ClientHUD.get_node("%NameLabel").text = "Name: "+$"..".player_names["client"]
