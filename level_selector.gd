extends Node

func _on_ninja_gardens_button_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/stages/ninja_gardens.tscn")


func _on_cowboy_desert_button_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/stages/cowboy_desert.tscn")


func _on_big_hands_city_button_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/stages/big_hands_city.tscn")
