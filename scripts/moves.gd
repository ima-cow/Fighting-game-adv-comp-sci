class_name Moves extends RefCounted

const JAB = preload("res://scenes/moves/blank_move.tscn")
const DASH = preload("res://scenes/moves/blank_move.tscn")
const TILT = preload("res://scenes/moves/blank_move.tscn")
const SMASH = preload("res://scenes/moves/blank_move.tscn")
const GRAB = preload("res://scenes/moves/blank_move.tscn")
const SPECIAL = preload("res://scenes/moves/blank_move.tscn")


static func jab(player_position: Vector2, player_direction: int):
	var attack = JAB.instantiate()
	attack.global_position = player_position

static func dash(player_position: Vector2, player_direction: int):
	var attack = DASH.instantiate()
	attack.global_position = player_position

static func tilt(player_position: Vector2, player_direction: int):
	var attack = TILT.instantiate()
	attack.global_position = player_position

static func smash(player_position: Vector2, player_direction: int):
	var attack = SMASH.instantiate()
	attack.global_position = player_position

static func grab(player_position: Vector2, player_direction: int):
	var attack = GRAB.instantiate()
	attack.global_position = player_position

static func special(player_position: Vector2, player_direction: int):
	var attack = SPECIAL.instantiate()
	attack.global_position = player_position

static func do_move(player_position: Vector2, player_direction: int,  input: InputEvent):
	if input.is_action_pressed("jab") && !input.is_action_pressed("move_left") && !input.is_action_pressed("move_right"):
		jab(player_position, player_direction)
	elif input.is_action_pressed("jab") && (input.is_action_pressed("move_left") || input.is_action_pressed("move_right")):
		dash(player_position, player_direction)
	elif input.is_action_pressed("tilt"):
		tilt(player_position, player_direction)
	elif input.is_action_pressed("smash"):
		smash(player_position, player_direction)
	elif input.is_action_pressed("grab"):
		grab(player_position, player_direction)
	elif input.is_action_pressed("special"):
		special(player_position, player_direction)
