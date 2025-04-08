extends TextureButton
class_name HoverButton


const AMOUNT: float = 0.2


var original_modulate: Color


func _ready():
	original_modulate = modulate


func _on_mouse_entered():
	modulate = modulate.darkened(AMOUNT)


func _on_mouse_exited():
	modulate = original_modulate
