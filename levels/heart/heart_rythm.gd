extends Timer
class_name HeartRythm


signal spawn_arrow

#This is completely unecesarry based on current implementation..
func _on_heart_rythm_timeout() -> void: 
	var random_number: int = randi()
	if random_number % 2 == 0:
		spawn_arrow.emit()
