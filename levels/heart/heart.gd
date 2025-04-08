extends Node2D
class_name Heart

@onready var arrow_spawns : Array[Node] = $Sprite2D/ScreenOverlay/ArrowSpawns.get_children()
@onready var arrow_despawn_point : Node2D = $ArrowDespawnPoint

@export var arrow_speed : float = 100.0

var rhythm_arrow = preload("res://entities/heart/rhythm_arrow.tscn")
var all_arrows : Array[CharacterBody2D] = []
var active_arrows : Array[CharacterBody2D] = []
var despawn_indices : Array[int] = []
var is_active: bool = false
### Variables for sprite directions ###
var sprite_left : int = 3
var sprite_up : int = 0
var sprite_down : int = 2
var sprite_right : int = 1
### Variables for sprite spawn indices ###
var left_spawn : Node
var up_spawn : Node
var down_spawn : Node
var right_spawn : Node

func _ready() -> void:
	left_spawn = arrow_spawns[0]
	up_spawn = arrow_spawns[1]
	down_spawn = arrow_spawns[2]
	right_spawn = arrow_spawns[3]

func _physics_process(delta: float) -> void:
	var arrow_index = 0
	for arrow in all_arrows:
		arrow.velocity.y = arrow_speed
		arrow.move_and_slide()
		
		# Add active arrows to the active arrow array
		if arrow.position.y <= arrow_despawn_point.position.y:
			active_arrows.append(arrow)
		else:
			#Track the indices of arrows to despawn
			despawn_indices.append(arrow_index)
		
		arrow_index += 1
	
	#Free despawning arrows from the queue
	for i in despawn_indices:
		all_arrows[i].queue_free()
	#Empty the despawn index array
	despawn_indices = []
	#Swap arrow array with active arrow array, then empty active arrow array
	all_arrows = active_arrows
	active_arrows = []

func _on_heart_rythm_spawn_arrow() -> void:
	#Create a new rhythm arrow, add it to the array of active arrows
	var new_arrow : CharacterBody2D = rhythm_arrow.instantiate()
	all_arrows.append(new_arrow)
	#Pick a random spawn point
	var random_spawn : Node = arrow_spawns.pick_random()
	#Add new arrow as child of chosen spawn
	random_spawn.add_child(new_arrow)
	
	#Change sprite of new arrow based on which spawn was chosen
	if random_spawn == left_spawn:
		new_arrow.set_sprite_frame(sprite_left)
	elif random_spawn == up_spawn:
		new_arrow.set_sprite_frame(sprite_up)
	elif random_spawn == down_spawn:
		new_arrow.set_sprite_frame(sprite_down)
	elif random_spawn == right_spawn:
		new_arrow.set_sprite_frame(sprite_right)
