extends Node3D

@onready var train: Train3D = get_parent()

func _input(event):
	if event is InputEventMultiScreenDrag and OS.has_feature("mobile"):
		if event.fingers == 2:
			var idx = get_current_camera_idx()
			set_current_camera(idx + -sign(event.relative.y))
			
	if event is InputEventMouseMotion:
		if event.shift_pressed and (event.button_mask & MOUSE_BUTTON_MASK_MIDDLE == MOUSE_BUTTON_MASK_MIDDLE):
			var idx = get_current_camera_idx()
			set_current_camera(idx + -sign(event.relative.y))
			

func get_current_camera_idx():
	var idx = 0
	for wagon in train.get_train_consist():
		if wagon.get_camera().current:
			return idx
		idx += 1
	return 0

func set_current_camera(idx: int):
	var wagons = train.get_train_consist()
	if idx < 0 or idx >= wagons.size():
		return
	wagons[idx].get_camera().current = true
	for wagon in wagons:
		if wagon == wagons[idx]:
			continue
		wagon.get_camera().current = false
