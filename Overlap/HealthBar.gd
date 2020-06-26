extends TextureProgress

onready var tween = $Tween

func update_bar(health, max_health):
	var previous_value = value
	max_value = max_health
	value = health
	var percent_hp = (value / max_value) * 100
	tween.interpolate_property(self, 'value', previous_value, value, 0.15, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	if percent_hp >= 60:
		set_tint_progress("14e114")
	elif percent_hp <= 60 and percent_hp >= 25:
		set_tint_progress("e1be32")
	else:
		set_tint_progress("e11e1e")

