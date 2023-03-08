@tool
extends HSlider

signal selected(value)

@export var default_value: float = 1


func _on_drag_ended(_value_changed):
	if value_changed:
		selected.emit(value)
	value = default_value
