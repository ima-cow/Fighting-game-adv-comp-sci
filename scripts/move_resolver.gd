class_name MoveResolver extends Node

@export var jab := preload("res://scenes/moves/blank_move.tscn")
@export var dash := preload("res://scenes/moves/blank_move.tscn")
@export var tilt := preload("res://scenes/moves/blank_move.tscn")
@export var smash := preload("res://scenes/moves/blank_move.tscn")
@export var grab := preload("res://scenes/moves/blank_move.tscn")
@export var special_1 := preload("res://scenes/moves/blank_move.tscn")
@export var special_2 := preload("res://scenes/moves/blank_move.tscn")

var player_position: Vector2

func instantiate_move(selected_move: PackedScene):
	var move: Area2D = selected_move.instantiate()
	add_child(move)
	move.global_position = player_position

func do_move(position: Vector2):
	player_position = position
	#spagetti code :/
	#lmk if you know any better way to do this
	if Input.is_action_just_pressed("jab") && !Input.is_action_pressed("move_left") && !Input.is_action_pressed("move_right"):
		instantiate_move(jab)
		print("jab")
	elif Input.is_action_just_pressed("jab") && (Input.is_action_pressed("move_left") || Input.is_action_pressed("move_right")):
		instantiate_move(dash)
		print("dash")
	elif Input.is_action_just_pressed("tilt"):
		instantiate_move(tilt)
		print("tilt")
	elif Input.is_action_just_pressed("smash"):
		instantiate_move(smash)
		print("smash")
	elif Input.is_action_just_pressed("grab"):
		instantiate_move(grab)
		print("grab")
	elif Input.is_action_just_pressed("special_1"):
		instantiate_move(special_1)
		print("special 1")
	elif Input.is_action_just_pressed("special_2"):
		instantiate_move(special_2)
		print("special 2")

func _on_move_spawner_spawned(node: Node2D) -> void:
	node.global_position = $"..".global_position
