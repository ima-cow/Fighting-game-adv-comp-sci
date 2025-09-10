extends CharacterBody2D

const JUMP_VELOCITY = -800.0
@export var speed = 400.0
@export var health = 100.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

func _process(delta: float) -> void:
	if health >= 0:
		queue_free()

	move_and_slide()


func _on_kill_zone_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
