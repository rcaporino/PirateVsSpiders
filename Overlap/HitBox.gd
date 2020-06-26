extends Area

export var damage = 1

func _ready():
	connect("area_entered", self, "collided")
	connect("body_entered", self, "collided")

func collided(area):
	if area.has_method("hit"):
		area.hit(damage)
