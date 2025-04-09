extends PanelContainer
class_name Action


@export var action_name: String
@export var time: float
@export var objectives: Array[Type]


signal completed
signal failed
signal hurry


enum Type {
	BRAIN,
	HEART,
	LUNGS
}
const TYPE_MAPPING: Dictionary = {
	Type.BRAIN: preload("res://resources/body_overview/brain_indicator.png"),
	Type.HEART: preload("res://resources/body_overview/heart_indicator.png"),
	Type.LUNGS: preload("res://resources/body_overview/lungs_indicator.png")
}

const ACTION_COMPONENT = preload("res://ui/action/action_component.tscn")


@onready var action_label: Label = $Name
@onready var objective_container: HBoxContainer = $Objectives
@onready var time_remaining: ProgressBar = $TimeRemaining
@onready var timer: Timer = $Timer

var objective_list: Dictionary = {} #Type: Array[Control]
var completed_count: int = 0:
	set(value):
		completed_count = value
		if completed_count == len(objectives):
			completed.emit()

class ActionData:
	var action_name: String
	var time: float
	var objectives: Array[Type]
	
	func _init(_action_name: String, _time: float, _actions: Array[Type]):
		action_name = _action_name
		time = _time
		objectives = _actions

static var ACTIONS: Array = [
	ActionData.new("Run", 150, [Type.LUNGS, Type.LUNGS, Type.HEART]),
	ActionData.new("Study", 150, [Type.BRAIN, Type.BRAIN, Type.BRAIN]),
	ActionData.new("Scary Movie", 180, [Type.HEART, Type.HEART, Type.BRAIN]),
	ActionData.new("Meditate", 210, [Type.LUNGS, Type.BRAIN, Type.LUNGS]),
	ActionData.new("Dance", 120, [Type.LUNGS, Type.HEART, Type.BRAIN]),
	ActionData.new("Video Game", 90, [Type.BRAIN, Type.HEART, Type.BRAIN]),
	ActionData.new("Heart Attack", 75, [Type.HEART, Type.HEART, Type.HEART]),
	ActionData.new("Mountain Hike", 150, [Type.LUNGS, Type.LUNGS, Type.LUNGS]),
]


func _ready() -> void:
	action_label.text = action_name
	for objective in objectives:
		var action_component_instance: ActionComponent = ACTION_COMPONENT.instantiate()
		action_component_instance.texture = TYPE_MAPPING[objective]
		if objective not in objective_list:
			objective_list[objective] = []
		objective_list[objective].append(action_component_instance)
		objective_container.add_child(action_component_instance)
	timer.wait_time = time
	timer.start()


func _process(_delta: float) -> void:
	if time_remaining.value >= 10 and (timer.time_left / timer.wait_time) * 100.0 < 10:
		hurry.emit()
	time_remaining.value = (timer.time_left / timer.wait_time) * 100.0


func _on_timer_timeout() -> void:
	failed.emit()


func handle_objective_completion(objective: Type) -> bool: #Return wether the objective was handled or not
	if not objective in objective_list:
		return false
	var components: Array = objective_list[objective]
	for component in components:
		if not component.completed:
			component.completed = true
			completed_count += 1
			return true
	return false
