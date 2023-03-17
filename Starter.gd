@tool
extends HSlider

signal selected(value)

var is_drag_started = false
@export var default_value: float = 1


func _on_drag_ended(_value_changed):
	if value_changed:
		selected.emit(value)
	value = default_value


func _on_drag_started():
	print("drag started")
	is_drag_started = true
