extends Window


func _input(event):
	print(OS.has_feature("mobile"))
	print(event)
	if event is InputEventScreenPinch and OS.has_feature("mobile"):
		
		var cam = (get_tree().get_root().get_node('Game/%MapCamera/MapCamera') as Camera3D)
		cam.size += -event.relative
		cam.size = clamp(cam.size, 20, 600)
	
	if event is InputEventScreenTwist and OS.has_feature("mobile"):
		var cam = (get_tree().get_root().get_node('Game/%MapCamera/MapCamera') as Camera3D)
		cam.rotation.y += event.relative
	
	if event is InputEventSingleScreenDrag and OS.has_feature("mobile"):
		var cam = (get_tree().get_root().get_node('Game/%MapCamera/MapCamera') as Camera3D)
		cam.global_position += Vector3(-event.relative.x, 0, -event.relative.y).rotated(Vector3.UP, cam.global_rotation.y) * remap(cam.size, 20, 600, 0.3, 1) * 0.01
	
	if event is InputEventSingleScreenTap and OS.has_feature("mobile"):
		_toggle_switch(event.position)

	if event is InputEventMouseMotion:
		if event.is_command_or_control_pressed() and event.button_mask & MOUSE_BUTTON_LEFT == MOUSE_BUTTON_LEFT:
			var cam = (get_tree().get_root().get_node('Game/%MapCamera/MapCamera') as Camera3D)
			cam.size += -event.relative.y
			cam.size = clamp(cam.size, 20, 600)

		if (not event.is_command_or_control_pressed()) and event.button_mask & MOUSE_BUTTON_LEFT == MOUSE_BUTTON_LEFT:
			var cam = (get_tree().get_root().get_node('Game/%MapCamera/MapCamera') as Camera3D)
			cam.global_position += Vector3(-event.relative.x, 0, -event.relative.y).rotated(Vector3.UP, cam.global_rotation.y) * remap(cam.size, 20, 600, 0.3, 1) * 0.1
	
	if event is InputEventMouseButton:
		if event.pressed and event.button_mask & MOUSE_BUTTON_LEFT == MOUSE_BUTTON_LEFT:
			var cam = (get_tree().get_root().get_node('Game/%MapCamera/MapCamera') as Camera3D)
			var from = cam.project_ray_origin(event.position)
			print(from)
			var to = from + cam.project_ray_normal(event.position) * 1000
			var params = PhysicsRayQueryParameters3D.new()
			params.from = from
			params.to = to
			params.collide_with_areas = true
			var collision = cam.get_world_3d().direct_space_state.intersect_ray(params)
			if collision.is_empty():
				return
			if collision.collider is Switch3D:
				collision.collider.toggle_switch()
			
func _toggle_switch(eve_position: Vector2):
	var cam = (get_tree().get_root().get_node('Game/%MapCamera/MapCamera') as Camera3D)
	var from = cam.project_ray_origin(eve_position)
	var to = from + cam.project_ray_normal(eve_position) * 1000
	
	var params = PhysicsRayQueryParameters3D.new()
	params.from = from
	params.to = to
	params.collide_with_areas = true
	
	var collision = cam.get_world_3d().direct_space_state.intersect_ray(params)
	if collision.is_empty():
		return
	if collision.collider is Switch3D:
		collision.collider.toggle_switch()
