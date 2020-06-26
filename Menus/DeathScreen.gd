extends Control

func _on_MainMenu_pressed():
	get_tree().paused = not get_tree().paused
	get_tree().change_scene("res://Menus/TitleScreen.tscn")

func _on_Quit_pressed():
	get_tree().quit()


func _on_DeathScreen_visibility_changed():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
