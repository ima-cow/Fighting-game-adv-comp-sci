extends Area2D

const START_UP = 0.1
const UP_TIME = 10000
const END_LAG = 0.1

func _ready() -> void:
	wait(START_UP)
	monitoring = true
	get_child(1).visible = true
	wait(UP_TIME+END_LAG)
	print("done")
	queue_free()

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
