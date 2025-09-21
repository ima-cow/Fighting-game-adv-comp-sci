extends Area2D

@export var start_up := 0.1
@export var up_time := 0.1
@export var end_lag := 0.1
@onready var character := $"../.."

func _ready() -> void:
	character.can_move = false
	await get_tree().create_timer(start_up).timeout
	monitoring = true
	$Sprite2D.visible = true
	await get_tree().create_timer(up_time).timeout
	monitoring = false
	$Sprite2D.visible = false
	await get_tree().create_timer(end_lag).timeout
	character.can_move = true
	queue_free()

func _physics_process(_delta: float) -> void:
	global_position = get_parent().get_parent().global_position

func _process(_delta: float) -> void:
	if character.get_child(0).flip_h:
		rotation_degrees = 180
		$Sprite2D.flip_v = true
	else:
		rotation_degrees = 0
		$Sprite2D.flip_v = false
