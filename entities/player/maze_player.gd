extends CharacterBody2D
class_name MazePlayer


@export var speed = 5 # How fast the player will move (pixels/sec).


@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1 * speed
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1 * speed
	if Input.is_action_pressed("move_down"):
		velocity.y += 1 * speed
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1 * speed
	
	if velocity.length() > 0:
		animated_sprite.animation = "move"
	else:
		animated_sprite.animation = "default"
	
	if velocity.length() > 0:
		rotation = atan2(velocity.y, velocity.x) - deg_to_rad(90)
	
	move_and_collide(velocity)
