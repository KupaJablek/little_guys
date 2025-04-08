extends Node2D

@onready var player : CharacterBody2D = $platformer_player
@onready var deoxygenated_cell : Area2D = $deoxygenated_cell
@onready var oxygen_depot : Area2D = $oxygen_depot
@onready var bg_music : AudioStreamPlayer = $background_music

@export var oxygen_needed : int = 10

var is_active : bool = true
var cells_oxygenated : int = 0

signal task_complete

func _ready() -> void:
	bg_music.play()

func _physics_process(delta: float) -> void:
	if is_active:
		if deoxygenated_cell.has_overlapping_bodies() and not player.has_cell:
			player.has_cell = true
			deoxygenated_cell.hide() #Cell is hidden until delivered
		if oxygen_depot.has_overlapping_bodies():
			if player.has_cell:
				cells_oxygenated += 1
				player.has_cell = false
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
