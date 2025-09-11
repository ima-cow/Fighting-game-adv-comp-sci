extends CharacterBody2D

const JUMP_VELOCITY = -800.0
@export var speed = 400.0
@export var health = 100.0


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

func _process(delta: float) -> void:
	if health <= 0:
		queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	health = 0
