extends Position3D


export (PackedScene) var spawnScene
#onready var spawnReference = load(spawnScene.get_path())
onready var spawnReference

export (NodePath) var timerPath
onready var timerNode = $Timer

export (float) var minWaitTime = 0
export (float) var maxWaitTime = .1

export (int) var map_x = 85
export (int) var map_z = 40

var spawned = 0
var number_of_enemies = -1
var enemies_at_start = -1
var starting_pos = get_global_transform()

func init(enemy_to_spawn, number_of_enemies_to_spawn_at_start, enemy_spawns):
	spawnReference = load(enemy_to_spawn)
	enemies_at_start = number_of_enemies_to_spawn_at_start
	number_of_enemies = enemy_spawns

func _ready():
	randomize()
	timerNode.set_wait_time(rand_range(minWaitTime, maxWaitTime))
	timerNode.start()

func _process(delta):
	if number_of_enemies <= 0:
		queue_free()

func get_random_location():
	var x_pos = rand_range(-map_x, map_x)
	var z_pos = rand_range(-map_z, map_z)
#	set_transform(starting_pos)
#	transform = transform.translated(Vector3(x_pos, 0, z_pos))
	global_transform = starting_pos
	global_transform = global_transform.translated(Vector3(x_pos, 0, z_pos))
	set_scale(Vector3(0.5, 0.5, 0.5))
	
func _on_Timer_timeout():
	number_of_enemies -= 1
	get_random_location()
	
	var spawnInstance = spawnReference.instance()
	
	get_parent().add_child(spawnInstance)
	spawnInstance.global_transform = global_transform
	
	spawned += 1
	if spawned == enemies_at_start:
		minWaitTime = 0.5
		maxWaitTime = 2
	
	timerNode.set_wait_time(rand_range(minWaitTime, maxWaitTime))
	timerNode.start()
