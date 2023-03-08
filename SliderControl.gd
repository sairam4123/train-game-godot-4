@tool
extends PanelContainer

@export
var value: float:
	get:
		if not is_inside_tree():
			return 0.0
		return $%SliderControl/VSlider.value
	set(value):
		if not is_inside_tree():
			return
		$%SliderControl/VSlider.value = value

@export_range(0, 1000000.0, 0.00001) var range_step = 0.1:
	set(new_value):
		range_step = new_value
		if is_inside_tree():
			$%SliderControl/VSlider.step = range_step

@export_multiline var text: String = "":
	set(new_value):
		text = new_value
		if is_inside_tree():
			$%SliderControl/Label.text = new_value

@export var value_format: String = "%s%%":
	set(new_value):
		value_format = new_value
		if is_inside_tree() and not use_value_enum:
			$%SliderControl/Value.text = value_format % value

@export var use_value_enum: bool = false:
	set(new_value):
		use_value_enum = new_value
		self.value_format = value_format
		self.value_enum = value_enum

@export var value_enum: Dictionary = {}:
	set(new_value):
		value_enum = new_value
		if is_inside_tree() and use_value_enum:
			$%SliderControl/Value.text = value_enum[int(value)]

func _on_v_slider_value_changed(value):
	self.use_value_enum = use_value_enum
