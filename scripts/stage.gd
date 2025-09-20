extends Node

func _on_ninja_button_button_up() -> void:
	add_child(preload("res://scenes/characters/ninja.tscn").instantiate())
	$CharacterSelector.queue_free()

func _on_cowboy_button_button_up() -> void:
	add_child(preload("res://scenes/characters/ninja.tscn").instantiate())
	$CharacterSelector.queue_free()

func _on_big_hands_button_button_up() -> void:
	add_child(preload("res://scenes/characters/ninja.tscn").instantiate())
	$CharacterSelector.queue_free()
