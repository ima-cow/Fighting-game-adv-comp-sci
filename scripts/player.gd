extends CharacterBody2D

const JUMP_VELOCITY := -100.0
const JUMP_MAX := 0.02
const SPEED := 400.0
const SPAWN_DISPLACEMENT := 300
@export var health := 100.0
@export var stocks := 3
@export var fliped := false;

const SERVER := 1
@export var player_id := -1

func _enter_tree() -> void:
	player_id = int(name)
	$PlayerSynchronizer.set_multiplayer_authority(player_id)
	$MoveSpawner.set_multiplayer_authority(player_id)

func _ready() -> void:
	if player_id != multiplayer.get_unique_id():
		set_process(false)
	
	if player_id == SERVER:
		position.x = -SPAWN_DISPLACEMENT
	else:
		position.x = SPAWN_DISPLACEMENT

func _physics_process(delta: float) -> void:
	if player_id == multiplayer.get_unique_id():
		_do_player_actions(delta)
	move_and_slide()

var can_move := true
var jump_holding_amount := 0.0
var can_jump := true
func _do_player_actions(delta: float):
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		can_jump = true
	
	if can_move:
		if Input.is_action_pressed("jump") and can_jump:
			if jump_holding_amount < JUMP_MAX:
				velocity.y += JUMP_VELOCITY
				jump_holding_amount += delta * 0.1
		else:
			jump_holding_amount = 0.0
			can_jump = false
		
		var direction := Input.get_axis("move_left", "move_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
		_move_through_platform()
		$MoveResolver.do_move(global_position)
	else:
		velocity.x *= 0.8

var first_recent_colision: StaticBody2D 
var second_recent_colision: StaticBody2D
func _move_through_platform():
	if get_slide_collision_count() == 0:
		return
	
	if get_slide_collision(0).get_collider() is StaticBody2D:
		first_recent_colision = get_slide_collision(0).get_collider()
	
	if Input.is_action_pressed("move_down") and is_on_floor():
		if first_recent_colision.get_meta("is_platform"):
			first_recent_colision.get_child(1).disabled = true
			second_recent_colision = first_recent_colision
	
	if second_recent_colision != null:
		if !first_recent_colision.get_meta("is_platform") and second_recent_colision.get_meta("is_platform"):
			second_recent_colision.get_child(1).disabled = false
			second_recent_colision = first_recent_colision

func _process(_delta: float) -> void:
	if Input.get_action_strength("move_right") > 0:
		$Sprite2D.flip_h = false
		fliped = false
	elif Input.get_action_strength("move_left") > 0:
		$Sprite2D.flip_h = true
		fliped = true

func _on_play_area_body_shaped_exited():
	health = 0
