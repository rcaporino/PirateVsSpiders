extends Sprite3D

onready var hp_bar = $Viewport/HealthBar

func _ready():
	texture = $Viewport.get_texture()

func update(health, max_health):
	hp_bar.update_bar(health, max_health)
