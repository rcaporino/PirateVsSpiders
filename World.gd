extends Node

var wave_number = 1
var num_spawners = -1
var enemies_to_spawn = -1
var enemies_to_spawn_at_start = -1
var enemies_remaining = -1


onready var Spawner = preload("res://Enemies/Spawner/Spawner.tscn")
onready var waveDisplay = $UIDisplay/HBoxContainer/VBoxContainer/WaveDisplay
onready var enemiesRemainingDisplay = $UIDisplay/HBoxContainer/VBoxContainer/EnemiesRemainingDisplay
onready var deathWaves = $DeathScreen/VBoxContainer/CenterContainer/VBoxContainer/WaveNumber
onready var waveTimer = $WaveTimer
onready var pirate = $Pirate

func _ready():
	start_new_wave()


func enemy_death():
	enemies_remaining -= 1
	enemiesRemainingDisplay.set_text("Enemies Remaining: " + str(enemies_remaining))
	if enemies_remaining == 0:
		end_current_wave()
		start_new_wave()

func end_current_wave():
	wave_number += 1

func start_new_wave():
	PlayerStats.health = PlayerStats.max_health
	pirate.update_healthbar()
	waveTimer.set_wait_time(3)
	waveTimer.start()
	waveTimer.show_message()
	yield(waveTimer, "timeout")
	num_spawners = 1
	enemies_to_spawn = ceil(wave_number * wave_number) + 10 + wave_number
	enemies_to_spawn_at_start = min((ceil(wave_number * wave_number) + 5 + wave_number), 20)
	enemies_remaining = enemies_to_spawn * num_spawners
	waveDisplay.set_text("Wave: " + str(wave_number))
	enemiesRemainingDisplay.set_text("Enemies Remaining: " + str(enemies_remaining))
	var spawner = Spawner.instance()
	spawner.init("res://Enemies/Spider.tscn", enemies_to_spawn_at_start, enemies_to_spawn)
	add_child(spawner)

func _on_Pirate_dead():
	get_tree().paused = not get_tree().paused
	deathWaves.set_text("You made it " + str(wave_number) + " waves")
	$DeathScreen.visible = true
