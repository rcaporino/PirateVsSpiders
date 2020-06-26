extends KinematicBody

signal dead

export var speed = 5
export var friction = 10
export var gravity = 80
export var wander_target_range = 4

onready var animationPlayer = $AnimationPlayer
onready var wanderController = $WanderController
onready var softCollision = $SoftCollision
onready var player = get_node("../Pirate")
onready var stats = $Stats
onready var healthBar3D = $HealthBar3D
onready var healthBarTween = $HealthBar3D/Viewport/HealthBar/Tween

enum {
	WANDER,
	ATTACK,
	IDLE
}

var state = IDLE
var can_fire = true
var fire_rate = .5
var velocity = Vector3()
var player_wr = null

func _ready():
	state = pick_random_state([ATTACK, WANDER])
	player_wr = weakref(player)
	healthBar3D.update(stats.health, stats.max_health)

func _physics_process(delta):
	move_and_collide(Vector3(0,-1,0))
#	state = WANDER
	match state:
		IDLE:
			animationPlayer.play("Idle")
			pass
#			velocity = velocity.move_toward(Vector3.ZERO, friction * delta)
#			animationPlayer.play("Idle")
#			if wanderController.get_time_left() == 0:
#				update_wander()
		WANDER:
			animationPlayer.play("Walk")
			if player_wr.get_ref():
				var to_player = translation.direction_to(player_wr.get_ref().translation)
				look_at_player()
				velocity = move_and_slide(to_player * speed)
			if wanderController.get_time_left() == 0:
				update_wander()
		ATTACK:
			velocity = velocity.move_toward(Vector3.ZERO, friction * delta)
			look_at_player()
			attack_laser()
			if wanderController.get_time_left() == 0:
				update_wander()
			
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	velocity = move_and_slide(velocity)

func attack_laser():
	if can_fire == true:
		animationPlayer.play("Attack")
		can_fire = false
		var laser = preload("res://Attacks/SpiderLaser.tscn")
		laser = laser.instance()
		laser.global_transform = global_transform.translated(Vector3(0, .5, 4)) 
		get_parent().add_child(laser)
		yield(get_tree().create_timer(fire_rate), "timeout")
		can_fire = true

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func update_wander():
	state = pick_random_state([ATTACK, WANDER])
	wanderController.set_wander_timer(rand_range(1,3))

func look_at_player():
	var player_pos = null
	if player_wr.get_ref():
		player_pos = player_wr.get_ref().translation
		look_at(player_pos + Vector3(0,.1,0), Vector3.UP)
		rotate_y(PI)


func _on_HurtBox_hit(damage):
	stats.health -= damage
	healthBar3D.update(stats.health, stats.max_health)


func _on_Stats_no_health():
	connect("dead", get_tree().current_scene, "enemy_death")
	emit_signal("dead")
	queue_free()
