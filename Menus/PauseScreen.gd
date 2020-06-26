extends Control

func _input(event):
	if event.is_action_pressed("pause"):
		get_tree().paused = not get_tree().paused
		visible = not visible
		if get_tree().paused:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _on_Resume_pressed():
	get_tree().paused = not get_tree().paused
	visible = not visible
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _on_Quit_pressed():
	get_tree().quit()
