@tool
extends HSlider

signal selected(value)

var is_drag_started = false
var selected_emitted = false
@export var default_value: float = 0.0
@export var filter_value: float = 1.0
@export var detectable_zone: float = 0.01

func _on_drag_ended(_value_changed):
	is_drag_started = false
	value = default_value
	selected_emitted = false


func _on_drag_started():
	is_drag_started = true

func _is_close_equal(a, b, d):
	return abs(a - b) < d
	
func _on_value_changed(value):
	if _is_close_equal(value, filter_value, detectable_zone) and is_drag_started and not selected_emitted:
		print("Filter emitting!", value)
		value = filter_value
		selected.emit(filter_value)
		selected_emitted = true
