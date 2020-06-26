extends Timer

onready var timeUntilNextWave = $TimeUntilNextWave
onready var timeUntilNextWaveDisplay = $TimeUntilNextWave/CenterContainer/Display

func _ready():
	pass # Replace with function body.

func _process(delta):
	var time = ceil(time_left)
	timeUntilNextWaveDisplay.set_text("Time until next wave: " + str(time))

func show_message():
	timeUntilNextWave.visible = true

func _on_WaveTimer_timeout():
	timeUntilNextWave.visible = false
