extends Node2D
class_name Heart

@onready var arrow_spawns : Array[Node] = $Sprite2D/ScreenOverlay/ArrowSpawns.get_children()
@onready var arrow_despawn_point : Node2D = $ArrowDespawnPoint
@onready var left_hitbox : Area2D = $Sprite2D/ScreenOverlay/ScreenArrows/LArrow
@onready var up_hitbox : Area2D = $Sprite2D/ScreenOverlay/ScreenArrows/UArrow
@onready var down_hitbox : Area2D = $Sprite2D/ScreenOverlay/ScreenArrows/DArrow
@onready var right_hitbox : Area2D = $Sprite2D/ScreenOverlay/ScreenArrows/RArrow
@onready var missed_beat_area : Area2D = $MissedBeatArea
@onready var player_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var bg_music : AudioStreamPlayer = $HeartMusic
@onready var heart_rythm: HeartRythm = $HeartRythm
@onready var remaining_value: Label = $Value

@export var arrow_speed : float = 100.0
@export var arrows_to_win : int = 10


var rhythm_arrow = preload("res://entities/heart/rhythm_arrow.tscn")
var success_counter : int = 0
var successful_arrow : Node = null
var all_arrows : Array[CharacterBody2D] = []
var active_arrows : Array[CharacterBody2D] = []
var despawn_indices : Array[int] = []
var is_active: bool = true
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

signal heart_complete


func _ready() -> void:
	left_spawn = arrow_spawns[0]
	up_spawn = arrow_spawns[1]
	down_spawn = arrow_spawns[2]
	right_spawn = arrow_spawns[3]


func _physics_process(_delta: float) -> void:
	move_arrows()
	
	if is_active:
		if Input.is_action_just_pressed("move_right"):
			if right_hitbox.has_overlapping_bodies():
				successful_arrow = right_hitbox.get_overlapping_bodies()[0]
				if not player_sprite.animation == "dance":
					player_sprite.animation = "dance"
				player_sprite.frame = randi() % 6
				success_counter += 1
		if Input.is_action_just_pressed("move_left"):
			if left_hitbox.has_overlapping_bodies():
				successful_arrow = left_hitbox.get_overlapping_bodies()[0]
				if not player_sprite.animation == "dance":
					player_sprite.animation = "dance"
				player_sprite.frame = randi() % 6
				success_counter += 1
		if Input.is_action_just_pressed("move_down"):
			if down_hitbox.has_overlapping_bodies():
				successful_arrow = down_hitbox.get_overlapping_bodies()[0]
				if not player_sprite.animation == "dance":
					player_sprite.animation = "dance"
				player_sprite.frame = randi() % 6
				success_counter += 1
		if Input.is_action_just_pressed("move_up"):
			if up_hitbox.has_overlapping_bodies():
				successful_arrow = up_hitbox.get_overlapping_bodies()[0]
				if not player_sprite.animation == "dance":
					player_sprite.animation = "dance"
				player_sprite.frame = randi() % 6
				success_counter += 1
	
	remaining_value.text = str(arrows_to_win - success_counter)
	#Free despawning arrows from the queue
	for i in despawn_indices:
		all_arrows[i].queue_free()
	#Empty the despawn index array
	despawn_indices = []
	#Swap arrow array with active arrow array, then empty active arrow array
	all_arrows = active_arrows
	active_arrows = []
	
	#Check for victory condition
	if success_counter == arrows_to_win:
		heart_complete.emit()
		success_counter = 0


func move_arrows() -> void:
	var arrow_index = 0
	for arrow in all_arrows:
		arrow.velocity.y = arrow_speed
		arrow.move_and_slide()
		
		if arrow == successful_arrow:
			#Mark succesful arrows to be removed
			despawn_indices.append(arrow_index)
		elif arrow.position.y <= arrow_despawn_point.position.y:
			# Add active arrows to the active arrow array
			active_arrows.append(arrow)
		else:
			#Track the indices of arrows to despawn
			despawn_indices.append(arrow_index)
		
		arrow_index += 1


func set_active_state(state : bool) -> void:
	is_active = state
	#Mute game if inactive, unmute if active
	if state:
		bg_music.volume_db = 0.0
	else:
		bg_music.volume_db = -80.0
	heart_rythm.paused = not state
	set_physics_process(state)


func _on_heart_rythm_timeout() -> void:
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


func _on_missed_beat_area_body_entered(_body: Node2D) -> void:
	if is_active: #Only play missed beat animation when player is in control
		player_sprite.animation = "fall"
		player_sprite.frame = randi() % 2
