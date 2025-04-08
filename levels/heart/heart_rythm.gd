extends Timer
class_name HeartRythm


@export var sprite: Sprite2D


func _on_heart_rythm_timeout() -> void:
	var random_number: int = randi()
	if random_number % 2 == 0:
		var sprite_instance: Sprite2D = sprite.instantiate()
		get_parent().add_child(sprite_instance)
