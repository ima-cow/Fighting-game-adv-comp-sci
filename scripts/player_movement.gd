extends CharacterBody2D

const JUMP_VELOCITY = -800.0
@export var speed = 400.0
@export var health = 100.0
var can_move = true

func _ready() -> void:
	$"../PlayArea".body_shape_exited.connect(_on_play_area_body_shaped_exited)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if can_move:
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		
		var direction := Input.get_axis("move_left", "move_right")
		if direction:
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
		
		$MoveResolver.do_move(global_position, 0)
	else:
		velocity.x *= 2 * delta
	
	move_and_slide()

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
