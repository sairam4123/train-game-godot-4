@tool
extends Area3D
class_name Switch3D

@export var main_path: Path3D
@export var verging_path: Path3D
@export var disabled: bool = false
@export var switch: bool = false:
	set(val):
		switch = val

@export var converging: bool = false:
	get:
		return converging


var invert: bool = false

@export var switch_direction: int = 1:
	set(value):
		if value in [-1, 1]:
			switch_direction = value
		else:
			return

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func toggle_switch():
	if not Engine.is_editor_hint() and disabled:
		return
	self.switch = !switch

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
