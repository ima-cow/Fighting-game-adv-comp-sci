class_name Moves extends Node

@onready var game = $"."
var jab_attack
var dash_attack
var tilt_attack
var smash_attack
var grab_attack
var special_attack_1
var special_attack_2

var player_position
var player_direction

func _init() -> void:
	jab_attack = preload("res://scenes/moves/blank_move.tscn")
	dash_attack = preload("res://scenes/moves/blank_move.tscn")
	tilt_attack = preload("res://scenes/moves/blank_move.tscn")
	smash_attack = preload("res://scenes/moves/blank_move.tscn")
	grab_attack = preload("res://scenes/moves/blank_move.tscn")
	special_attack_1 = preload("res://scenes/moves/blank_move.tscn")
	special_attack_2 = preload("res://scenes/moves/blank_move.tscn")

func jab():
	print(player_position)
	var attack = jab_attack.instantiate()
	game.add_child(attack)
	attack.global_position = player_position
	print(attack.global_position)

func dash():
	var attack = dash_attack.instantiate()
	attack.global_position = player_position

func tilt():
	var attack = tilt_attack.instantiate()
	attack.global_position = player_position

func smash():
	var attack = smash_attack.instantiate()
	attack.global_position = player_position

func grab():
	var attack = grab_attack.instantiate()
	attack.global_position = player_position

func special_1():
	var attack = special_attack_1.instantiate()
	attack.global_position = player_position

func special_2():
	var attack = special_attack_2.instantiate()
	attack.global_position = player_position

func do_move(position: Vector2, direction: int):
	player_position = position
	player_direction = direction
	if Input.is_action_just_pressed("jab") && !Input.is_action_pressed("move_left") && !Input.is_action_pressed("move_right"):
		jab()
		print("jab")
	elif Input.is_action_just_pressed("jab") && (Input.is_action_pressed("move_left") || Input.is_action_pressed("move_right")):
		dash()
	elif Input.is_action_just_pressed("tilt"):
		tilt()
	elif Input.is_action_just_pressed("smash"):
		smash()
	elif Input.is_action_just_pressed("grab"):
		grab()
	elif Input.is_action_just_pressed("special_1"):
		special_1()
	elif Input.is_action_just_pressed("special_2"):
		special_2()
