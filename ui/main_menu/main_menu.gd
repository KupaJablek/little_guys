extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_button_pressed() -> void:
	# get_tree().change_scene_to_file(start scene)
	print("Start pressed")


func _on_settings_button_pressed() -> void:
	# get_tree().change_scene_to_file("res://iu/settings_menu.tscn")
	print("Settings pressed")


func _on_exit_button_pressed() -> void:
	print("exit pressed")
	get_tree().quit()
