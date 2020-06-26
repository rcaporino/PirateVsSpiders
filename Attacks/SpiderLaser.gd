extends "res://Attacks/ProjectileAttack.gd"

const LaserSound = preload("res://Sounds/Laser.tscn")

func _ready():
	var laserSound = LaserSound.instance()
	get_tree().current_scene.add_child(laserSound)
