extends CanvasLayer
class_name Pause


@onready var button_sound: AudioStreamPlayer = $"../ButtonPress"


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		visible = not visible
	get_tree().paused = visible


func _on_resume_button_pressed() -> void:
	hide()
	button_sound.play()


func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://ui/main_menu/main_menu.tscn")


func _on_exit_button_pressed() -> void:
	get_tree().quit()
