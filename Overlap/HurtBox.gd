extends Area

signal hit(damage)


func _ready():
	pass # Replace with function body.

func hit(damage):
	emit_signal("hit", damage)

