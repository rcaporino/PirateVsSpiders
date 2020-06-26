extends "res://Attacks/ProjectileAttack.gd"

const FireballCast = preload("res://Sounds/FireballCast.tscn")
const FireballExplosion = preload("res://Sounds/FireballExplosion.tscn")

func _ready():
	area.connect("area_entered", self, "make_explosion")
	area.connect("body_entered", self, "make_explosion")
	var fireballCast = FireballCast.instance()
	get_tree().current_scene.add_child(fireballCast)

func make_explosion(area):
	var explosion = preload("res://Attacks/Explosion.tscn")
	explosion = explosion.instance()
	explosion.global_transform = global_transform.translated(Vector3(0, 0, -1)) 
	explosion.get_child(0).set_emitting(true)
	get_tree().current_scene.add_child(explosion)
	var fireballExplosion = FireballExplosion.instance()
	get_tree().current_scene.add_child(fireballExplosion)
