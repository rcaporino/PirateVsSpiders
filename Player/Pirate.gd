extends KinematicBody

signal dead

export var speed = 150
export var friction = 0.875
export var gravity = 80

var move_direction = Vector3()
var vel = Vector3()
var can_fire = true
var fire_rate = 0.3
var stats = PlayerStats

const HitSound = preload("res://Overlap/HitSound.tscn")

onready var camera = $CameraRig/Camera
onready var camera_rig = $CameraRig
onready var cursor = $Cursor
onready var animationPlayer = $AnimationPlayer
onready var hurt_box = $HurtBox
onready var healthBar3D = $HealthBar3D

func _ready():
	stats.health = stats.max_health
	camera_rig.set_as_toplevel(true)
	cursor.set_as_toplevel(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	animationPlayer.play("Walking3D")
	stats.connect("no_health", self, "dead")
	healthBar3D.update(stats.health, stats.max_health)
	
func _physics_process(delta):
	camera_follows_player()
	
	look_at_cursor()
	run(delta)
	
	vel *= friction
	vel.y -= gravity * delta
	vel = move_and_slide(vel, Vector3.UP, true, 3)
	
	if(Input.get_action_strength("fire")):
		attack_fireball()
	
func camera_follows_player():
	var player_pos = global_transform.origin
	camera_rig.global_transform.origin = player_pos

func look_at_cursor():
	var player_pos = global_transform.origin
	var dropPlane = Plane(Vector3(0, 1, 0), player_pos.y)
	
	var ray_length = 1000
	var mouse_pos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * ray_length
	var cursor_pos = dropPlane.intersects_ray(from, to)
	
	cursor.global_transform.origin = cursor_pos + Vector3(0, 1, 0)
	look_at(cursor_pos, Vector3.UP)
	rotate_y(PI)

func run(delta):
	move_direction = Vector3()
	var camera_basis = camera.get_global_transform().basis
	var input_vector = Vector2()
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	move_direction += camera_basis.z * input_vector.y
	move_direction += camera_basis.x * input_vector.x

	move_direction.y = 0
	move_direction = move_direction.normalized()
	
	vel += move_direction * speed * delta

func attack_fireball():
	if can_fire == true:
		can_fire = false
		var fireball = preload("res://Attacks/Fireball.tscn")
		fireball = fireball.instance()
		fireball.global_transform = global_transform.translated(Vector3(0, 1, .9)) 
		get_parent().add_child(fireball)
		yield(get_tree().create_timer(fire_rate), "timeout")
		can_fire = true

func dead():
	var new_cam_rig = preload("res://CameraRig.tscn")
	new_cam_rig = new_cam_rig.instance()
	new_cam_rig.global_transform = camera_rig.global_transform.translated(Vector3(0,0,0))
	get_parent().add_child(new_cam_rig)
	emit_signal("dead")
	queue_free()
	pass

func update_healthbar():
	healthBar3D.update(stats.health, stats.max_health)

func _on_HurtBox_hit(damage):
	stats.health -= damage
	update_healthbar()
	var hitSound = HitSound.instance()
	get_tree().current_scene.add_child(hitSound)

