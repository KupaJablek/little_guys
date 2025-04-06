extends Control

@onready var maze_game : Maze = $Brain/HBoxContainer/brain_monitor/SubViewportContainer/SubViewport/Maze
@onready var platformer_game= $Lungs/HBoxContainer/lungs_monitor/SubViewportContainer/SubViewport
@onready var rhythm_game = $Heart/HBoxContainer/heart_monitor/SubViewportContainer/SubViewport

func _ready() -> void:
	maze_game.is_active = false
	#platformer_game.is_active = false
	#rhythm_game.is_active = false

func _on_brain_button_pressed() -> void:
	maze_game.is_active = true
	#platformer_game.is_active = false
	#rhythm_game.is_active = false
	


func _on_lungs_button_pressed() -> void:
	maze_game.is_active = false
	#platformer_game.is_active = true
	#rhythm_game.is_active = false
	


func _on_heart_button_pressed() -> void:
	maze_game.is_active = false
	#platformer_game.is_active = false
	#rhythm_game.is_active = true
