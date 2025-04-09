extends Control

@onready var maze_game : Maze = $Brain/HBoxContainer/brain_monitor/SubViewportContainer/SubViewport/Maze
@onready var platformer_game= $Lungs/HBoxContainer/lungs_monitor/SubViewportContainer/SubViewport/platformer
@onready var rhythm_game = $Heart/HBoxContainer/heart_monitor/SubViewportContainer/SubViewport/Heart
@onready var action_list = $Action

func _ready() -> void:
	maze_game.set_active_state(false)
	platformer_game.set_active_state(false)
	rhythm_game.set_active_state(false)


func _on_brain_button_pressed() -> void:
	maze_game.set_active_state(true)
	platformer_game.set_active_state(false)
	rhythm_game.set_active_state(false)
	


func _on_lungs_button_pressed() -> void:
	maze_game.set_active_state(false)
	platformer_game.set_active_state(true)
	rhythm_game.set_active_state(false)
	


func _on_heart_button_pressed() -> void:
	maze_game.set_active_state(false)
	platformer_game.set_active_state(false)
	rhythm_game.set_active_state(true)


func _on_platformer_lung_complete() -> void:
	action_list.handle_objective_completion(action_list.Type.LUNGS)


func _on_heart_heart_complete() -> void:
	action_list.handle_objective_completion(action_list.Type.HEART)
