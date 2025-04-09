extends Control
class_name BodyOverview


const IAction = preload("res://ui/action/action.tscn")


@onready var maze_game : Maze = $Brain/brain_monitor/SubViewportContainer/SubViewport/Maze
@onready var platformer_game= $Lungs/lungs_monitor/SubViewportContainer/SubViewport/platformer
@onready var rhythm_game = $Heart/heart_monitor/SubViewportContainer/SubViewport/Heart
@onready var success_sound : AudioStreamPlayer = $GameSuccess
@onready var fail_sound : AudioStreamPlayer = $TaskFail
@onready var button_sound : AudioStreamPlayer = $ButtonPress
@onready var brain_shader: ShaderMaterial = $big_guy/brain.material
@onready var lungs_shader: ShaderMaterial = $big_guy/lungs.material
@onready var heart_shader: ShaderMaterial = $big_guy/heart.material
@onready var action_list: VBoxContainer = $ActionList
@onready var score_value: Label = $ScoreValue


var score: int = 0:
	set(value):
		score = value
		if not is_node_ready():
			await ready
		score_value.text = str(score)


func _ready() -> void:
	maze_game.set_active_state(false)
	platformer_game.set_active_state(false)
	rhythm_game.set_active_state(false)
	score = 0


func _on_brain_button_pressed() -> void:
	button_sound.play()
	maze_game.set_active_state(true)
	platformer_game.set_active_state(false)
	rhythm_game.set_active_state(false)
	brain_shader.set_shader_parameter("width", 2)
	lungs_shader.set_shader_parameter("width", 0)
	heart_shader.set_shader_parameter("width", 0)


func _on_lungs_button_pressed() -> void:
	button_sound.play()
	maze_game.set_active_state(false)
	platformer_game.set_active_state(true)
	rhythm_game.set_active_state(false)
	brain_shader.set_shader_parameter("width", 0)
	lungs_shader.set_shader_parameter("width", 2)
	heart_shader.set_shader_parameter("width", 0)


func _on_heart_button_pressed() -> void:
	button_sound.play()
	maze_game.set_active_state(false)
	platformer_game.set_active_state(false)
	rhythm_game.set_active_state(true)
	brain_shader.set_shader_parameter("width", 0)
	lungs_shader.set_shader_parameter("width", 0)
	heart_shader.set_shader_parameter("width", 2)


func _on_platformer_lung_complete() -> void:
	handle_action_completion(Action.Type.LUNGS)


func _on_heart_heart_complete() -> void:
	handle_action_completion(Action.Type.HEART)


func _on_brain_complete() -> void:
	handle_action_completion(Action.Type.BRAIN)


func handle_action_completion(type: Action.Type):
	success_sound.play()
	for i in range(action_list.get_child_count()):
		var action: Action = action_list.get_child(i)
		if action.handle_objective_completion(type):
			break


func _on_action_spawner_timeout() -> void:
	if action_list.get_child_count() < 3:
		var action_instance: Action = IAction.instantiate()
		var action_data: Action.ActionData = Action.ACTIONS.pick_random()
		action_instance.action_name = action_data.action_name
		action_instance.time = action_data.time
		action_instance.objectives = action_data.objectives
		action_instance.completed.connect(action_completed.bind(action_instance))
		action_instance.failed.connect(action_failed.bind(action_instance))
		action_list.add_child(action_instance)


func action_completed(action: Action):
	score += 20
	action.queue_free()


func action_failed(action: Action):
	score -= 5
	action.queue_free()
