extends Spatial

export(int) var wander_range = 32

onready var start_position = global_transform
onready var target_position = global_transform

onready var timer = $Timer

func _ready():
	update_target_position()

func update_target_position():
	var target_vector = Vector3(rand_range(-wander_range, wander_range), 0,  rand_range(-wander_range, wander_range))
	target_position = start_position.translated(target_vector)

func get_time_left():
	return timer.time_left

func set_wander_timer(duration):
	timer.start(duration)


func _on_Timer_timeout():
	pass
