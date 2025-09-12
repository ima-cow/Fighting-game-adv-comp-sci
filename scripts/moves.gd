class_name Moves extends RefCounted

static var JAB = preload("res://scenes/moves/blank_move.tscn")
static var DASH = preload("res://scenes/moves/blank_move.tscn")
static var TILT = preload("res://scenes/moves/blank_move.tscn")
static var SMASH = preload("res://scenes/moves/blank_move.tscn")
static var GRAB = preload("res://scenes/moves/blank_move.tscn")
static var SPECIAL = preload("res://scenes/moves/blank_move.tscn")


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

static func do_move(player_position: Vector2, player_direction: int):
	if Input.is_action_pressed("jab") && !Input.is_action_pressed("move_left") && !Input.is_action_pressed("move_right"):
		jab(player_position, player_direction)
	elif Input.is_action_pressed("jab") && (Input.is_action_pressed("move_left") || Input.is_action_pressed("move_right")):
		dash(player_position, player_direction)
	elif Input.is_action_pressed("tilt"):
		tilt(player_position, player_direction)
	elif Input.is_action_pressed("smash"):
		smash(player_position, player_direction)
	elif Input.is_action_pressed("grab"):
		grab(player_position, player_direction)
	elif Input.is_action_pressed("special"):
		special(player_position, player_direction)
