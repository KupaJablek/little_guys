extends Node2D

@onready var player : CharacterBody2D = $platformer_player
@onready var deoxygenated_cell : Area2D = $deoxygenated_cell
@onready var oxygen_depot : Area2D = $oxygen_depot
@onready var bg_music : AudioStreamPlayer = $background_music
@onready var cell_spawns : Array[Node] = $cell_spawns.get_children()
@onready var oxygen_spawns : Array[Node] = $oxygen_spawns.get_children()

@export var oxygen_needed : int = 10

var is_active : bool = true
var cells_oxygenated : int = 0

signal task_complete

func _ready() -> void:
	bg_music.play()
	#Move deoxygenated cell and oxygen depot to random spawn
	change_spawns()

func _physics_process(delta: float) -> void:
	if is_active:
		if deoxygenated_cell.has_overlapping_bodies() and not player.has_cell:
			player.has_cell = true
			deoxygenated_cell.hide() #Cell is hidden until delivered
		if oxygen_depot.has_overlapping_bodies():
			if player.has_cell:
				cells_oxygenated += 1
				player.has_cell = false
				change_spawns()
				deoxygenated_cell.show() #Cell appears in new area
				
				if cells_oxygenated == oxygen_needed:
					task_complete.emit()
					cells_oxygenated = 0 #Reset cell counter

func set_active_state(active_state : bool) -> void:
	is_active = active_state
	player.can_move = active_state
	
	if active_state:
		bg_music.volume_db = 0.0
	else:
		bg_music.volume_db = -80.0

func change_spawns() -> void:
	#Pick a random cell and oxygen spawn from each array
	var random_cell_spawn : Node = cell_spawns[randi() % cell_spawns.size()]
	var random_oxygen_spawn : Node = oxygen_spawns[randi() % oxygen_spawns.size()]
	
	#Move the cell and oxygen depot to the chosen spawn
	deoxygenated_cell.position = random_cell_spawn.position
	oxygen_depot.position = random_oxygen_spawn.position
