extends Area2D

@export var start_up = 0.1
@export var up_time = 0.1
@export var end_lag = 0.1

func _ready() -> void:
	get_parent().get_parent().can_move = false
	await get_tree().create_timer(start_up).timeout
	monitoring = true
	get_child(1).visible = true
	await get_tree().create_timer(up_time).timeout
	monitoring = false
	get_child(1).visible = false
	await get_tree().create_timer(end_lag).timeout
	get_parent().get_parent().can_move = true
	queue_free()
