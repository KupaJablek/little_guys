extends TextureRect
class_name ActionComponent


@onready var check_mark: TextureRect = $CheckMark


var completed: bool = false:
	set(value):
		completed = value
		check_mark.visible = completed
		self_modulate.a = 0.5 if completed else 1.0
