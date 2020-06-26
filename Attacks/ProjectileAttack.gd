extends Spatial

export var projectile_speed = 50
export var damage = 15

onready var area = $Area

const KILL_TIMER = 4
var timer = 0

var hit_something = false

func _ready():
	area.connect("area_entered", self, "collided")
	area.connect("body_entered", self, "collided")

func _physics_process(delta):
	var forward_dir = global_transform.basis.z.normalized()
	global_translate(forward_dir * projectile_speed * delta)

	timer += delta
	if timer >= KILL_TIMER:
		queue_free()


func collided(area):
	if hit_something == false:
		if area.has_method("hit"):
			area.hit(damage)
	hit_something = true
	
	queue_free()
