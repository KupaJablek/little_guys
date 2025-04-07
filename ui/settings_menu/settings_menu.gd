extends Control

var dec = preload("res://resources/UI/Settings_menu/settings_down_btn.png")
var inc = preload("res://resources/UI/Settings_menu/settings_up_btn.png")

var dec_highlighted = preload("res://resources/UI/Settings_menu/settings_down_btn_highlight.png")
var inc_highlighted = preload("res://resources/UI/Settings_menu/settings_up_btn_highlight.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_dec_button_pressed() -> void:
	print("increase button pressed")


func _on_inc_button_pressed() -> void:
	print("increae button pressed")


func _on_back_button_pressed() -> void:
	# get_tree().change_scene_to_file("res://ui/main_menu/main_menu.tscn")
	print("back pressed")
	get_tree().quit()


func _on_decrease_volume_focus_entered() -> void:
	$DecreaseVolume.icon = dec_highlighted
func _on_decrease_volume_mouse_entered() -> void:
	$DecreaseVolume.icon = dec_highlighted

func _on_decrease_volume_mouse_exited() -> void:
	$DecreaseVolume.icon = dec
func _on_decrease_volume_focus_exited() -> void:
	$DecreaseVolume.icon = dec


func _on_increase_volume_focus_entered() -> void:
	$IncreaseVolume.icon = inc_highlighted
func _on_increase_volume_mouse_entered() -> void:
	$IncreaseVolume.icon = inc_highlighted

func _on_increase_volume_mouse_exited() -> void:
	$IncreaseVolume.icon = inc
func _on_increase_volume_focus_exited() -> void:
	$IncreaseVolume.icon = inc


func _on_increase_volume_pressed() -> void:
	pass # Replace with function body.
