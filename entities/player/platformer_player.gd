extends CharacterBody2D

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D

var speed : float = 10.0
var gravity : float = 10.0
var can_move : bool = true

func _physics_process(delta: float) -> void:
	if is_on_floor():
		velocity.y = 0.0
		
		if can_move:
			velocity.x = Input.get_vector("move_left", "move_right", "move_up", "move_down").x * speed
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
	
	else:
		velocity.y += gravity
		sprite.play("falling")
	
	move_and_slide()
