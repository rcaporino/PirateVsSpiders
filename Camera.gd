extends Camera

#onready var character = get_node("../Pirate")
onready var character = get_parent()
onready var offset = get_global_transform().origin

func _ready():
	set_as_toplevel(true)

func _physics_process(delta):
	var target = character.get_global_transform().origin
	var base  = get_global_transform().basis
	set_global_transform(Transform(base, target + offset))
