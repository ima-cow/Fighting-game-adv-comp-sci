class_name MoveResolver extends Node

signal move_instantiated(player_hit_id: int, damage: float, knockback: Vector2)

@export var jab := preload("res://scenes/moves/blank_move.tscn")
@export var smash := preload("res://scenes/moves/smash.tscn")
@export var special_1 := preload("res://scenes/moves/blank_move.tscn")

var player_position: Vector2

func do_move(position: Vector2):
	player_position = position
	#spagetti code :/
	#lmk if you know any better way to do this
	if Input.is_action_just_pressed("jab"):
		print("jab")
		instantiate_move(jab)
	elif Input.is_action_just_pressed("smash"):
		print("smash")
		instantiate_move(smash)
	elif Input.is_action_just_pressed("special_1"):
		print("special 1")
		instantiate_move(special_1)

func instantiate_move(selected_move: PackedScene):
	var move: Area2D = selected_move.instantiate()
	add_child(move)
	move.global_position = player_position
	move.body_shape_entered.connect(_on_move_body_shape_entered)

func _on_move_spawner_spawned(node: Node2D):
	node.global_position = $"..".global_position

func _on_move_body_shape_entered(_body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int):
	if body != $"..":
		move_instantiated.emit(body.player_id, get_child(0).damage, get_child(0).knockback)
