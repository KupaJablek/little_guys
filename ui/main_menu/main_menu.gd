extends Control
class_name MainMenu


func _on_start_button_pressed() -> void:
	# get_tree().change_scene_to_file(start scene)
	print("Start pressed")


func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file("res://ui/settings_menu/settings_menu.tscn")
	print("Settings pressed")


func _on_exit_button_pressed() -> void:
	print("exit pressed")
	get_tree().quit()
