extends CharacterBody2D

const JUMP_VELOCITY := -550.0
const JUMP_MULTIPLIER := 2
@export var speed := 400.0
@export var health := 100.0
var can_move := true

@export var player_id := 1:
	set(id):
		player_id = id
		$InputSynchronizer.set_multiplayer_authority(id)

#func _ready() -> void:
	#$"../PlayArea".body_shape_exited.connect(_on_play_area_body_shaped_exited)

func _physics_process(delta: float) -> void:
	if multiplayer.is_server():
		apply_movement_from_input(delta)

func apply_movement_from_input(delta: float):
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if can_move:
		if $InputSynchronizer.jump_released:
			velocity.y = JUMP_VELOCITY * $InputSynchronizer.jump_holding_amount
		
		var direction = $InputSynchronizer.input_direction
		if direction:
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
		
		move_through_platform()
		$MoveResolver.do_move(global_position)
	else:
		velocity.x *= 0.8
	
	move_and_slide()

var first_recent_colision: StaticBody2D 
var second_recent_colision: StaticBody2D
func move_through_platform():
	if get_slide_collision_count() == 0:
		return
	
	if get_slide_collision(0) != null and get_slide_collision(0).get_collider() is StaticBody2D:
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
	if health <= 0:
		print("YOU DIED!")
		queue_free()
	
	if velocity.x < 0:
		$Sprite2D.flip_h = true
	elif velocity.x > 0:
		$Sprite2D.flip_h = false

func _on_play_area_body_shaped_exited():
	health = 0
