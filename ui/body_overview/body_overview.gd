extends Control

@onready var maze_game : Maze = $Brain/HBoxContainer/brain_monitor/SubViewportContainer/SubViewport/Maze
@onready var platformer_game= $Lungs/HBoxContainer/lungs_monitor/SubViewportContainer/SubViewport
@onready var rhythm_game = $Heart/HBoxContainer/heart_monitor/SubViewportContainer/SubViewport/Heart

func _ready() -> void:
	maze_game.set_active_state(false)
	#platformer_game.set_active_state(false)
	rhythm_game.set_active_state(false)

func _on_brain_button_pressed() -> void:
	maze_game.set_active_state(true)
	#platformer_game.set_active_state(false)
	rhythm_game.set_active_state(false)
	


func _on_lungs_button_pressed() -> void:
	maze_game.set_active_state(false)
	#platformer_game.set_active_state(true)
	rhythm_game.set_active_state(false)
	


func _on_heart_button_pressed() -> void:
	maze_game.set_active_state(false)
	#platformer_game.set_active_state(false)
	rhythm_game.set_active_state(true)
