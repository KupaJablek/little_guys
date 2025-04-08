extends CharacterBody2D

@onready var sprite = $sprite

func set_sprite_frame(frame : int) -> void:
	sprite.frame = frame
