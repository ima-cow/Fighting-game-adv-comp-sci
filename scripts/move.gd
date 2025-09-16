extends Area2D

@export var start_up = 0.1
@export var up_time = 0.1
@export var end_lag = 0.1

func _ready() -> void:
	$"../..".can_move = false
	await get_tree().create_timer(start_up).timeout
	monitoring = true
	$Sprite2D.visible = true
	await get_tree().create_timer(up_time).timeout
	monitoring = false
	$Sprite2D.visible = false
	await get_tree().create_timer(end_lag).timeout
	$"../..".can_move = true
	queue_free()

func _physics_process(delta: float) -> void:
	global_position = get_parent().get_parent().global_position

#func _process(delta: float) -> void:
	#if 
