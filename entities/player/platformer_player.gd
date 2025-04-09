extends CharacterBody2D

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox : CollisionShape2D = $CollisionShape2D
@onready var ladder_beneath_checker : Area2D = $ladder_beneath_checker
@onready var ladder_behind_checker : Area2D = $ladder_behind_checker

@export var speed : float = 75.0
@export var climb_speed : float = 50.0
@export var gravity : float = 10.0

var is_on_ladder : bool = false
var just_started_climbing : bool = false
var can_move : bool = true

var has_cell : bool = false

func _physics_process(_delta: float) -> void:
	if is_on_ladder:
		climb()
	
	elif is_on_floor():
		if not sprite.is_playing():
			sprite.play()
		
		velocity.y = 0.0
		walk()
	
	else:
		velocity.y += gravity
		sprite.play("falling")
	
	move_and_slide()

func climb() -> void:
	if can_move:
		var temp_velocity : Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		velocity.y = temp_velocity.y * climb_speed
		if temp_velocity.x != 0 and ladder_beneath_checker.has_overlapping_bodies():
			dismount_ladder()
		if velocity.y > 0.0:
			if not ladder_beneath_checker.has_overlapping_bodies() and just_started_climbing: #Don't check for ground until after leaving first ground
				just_started_climbing = false
			elif ladder_beneath_checker.has_overlapping_bodies() and not just_started_climbing:
				dismount_ladder()
		elif not ladder_behind_checker.has_overlapping_bodies() and velocity.y < 0.0:
			dismount_ladder()
	else:
		velocity.y = 0.0
		
	sprite.play("climbing")
	if velocity.y == 0.0:
		sprite.pause()

func walk() -> void:
	if can_move:
		var temp_velocity : Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		if temp_velocity.y > 0.0 and ladder_beneath_checker.has_overlapping_bodies(): #If moving down and ladder is underneath
			mount_ladder()
		elif temp_velocity.y < 0.0 and ladder_behind_checker.has_overlapping_bodies(): #If moving up and overlapping with a ladder
			mount_ladder()
		else:
			velocity.x = temp_velocity.x * speed
	else:
		velocity.x = 0.0
	
	if velocity.x > 0.0: # Player moving right
		sprite.play("walking")
		sprite.flip_h = false
	elif velocity.x < 0.0: # Player moving left
		sprite.play("walking")
		sprite.flip_h = true
	else: #Player standing still
		sprite.play("default")

func mount_ladder() -> void: #Sets player settings to climb mode
	velocity.x = 0.0
	is_on_ladder = true
	just_started_climbing = true
	set_collision_mask_value(3, false) #allows player to move through inner floors while on ladder
	ladder_beneath_checker.set_collision_mask_value(2, true) #Start checking for solid ground
	ladder_beneath_checker.set_collision_mask_value(3, true)
	ladder_beneath_checker.set_collision_mask_value(4, false) #Stop checking for ladders

func dismount_ladder() -> void: #Resets player settings to ground mode
	is_on_ladder = false
	set_collision_mask_value(3, true) #Reenable collision with inner ground
	ladder_beneath_checker.set_collision_mask_value(2, false) #Stop checking for solid ground
	ladder_beneath_checker.set_collision_mask_value(3, false)
	ladder_beneath_checker.set_collision_mask_value(4, true) #Start checking for ladders
