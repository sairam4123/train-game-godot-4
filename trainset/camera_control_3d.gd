extends Node3D


func _input(event):
	if event is InputEventMouseMotion:
		if event.button_mask & MOUSE_BUTTON_MASK_MIDDLE == MOUSE_BUTTON_MASK_MIDDLE:
			if event.is_command_or_control_pressed():
				$CameraRotate/Camera3D.position.z += -event.relative.y * 0.1
			else:
				# rotate
				rotate_y(-event.relative.x * 0.01)
				$CameraRotate.rotate_x(-event.relative.y * 0.01)
