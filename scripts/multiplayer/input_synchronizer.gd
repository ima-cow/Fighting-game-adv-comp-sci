extends MultiplayerSynchronizer

@onready var input_direction := Input.get_axis("move_left", "move_right")
@onready var jump_released := false
@onready var jump_holding_amount := 1.0

func _ready() -> void:
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		set_physics_process(false)

func _physics_process(delta: float) -> void:
	input_direction = Input.get_axis("move_left", "move_right")
	print(get_parent(), get_parent().get_slide_collision_count())
	if Input.is_action_just_released("jump") and get_parent().is_on_floor():
		jump_released = true
		jump_holding_amount = 1.0
	else:
		jump_released = false
	if Input.is_action_pressed("jump") and get_parent().is_on_floor():
		if jump_holding_amount < 2:
			jump_holding_amount += get_parent().JUMP_MULTIPLIER * delta
