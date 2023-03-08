extends BasicLocomotive3D
class_name PlayerLocomotive3D

var is_inside_switch_area: bool = false
var switch_area: Switch3D
var in_switch_progress: bool = false


func _ready():
	super()
	
	UIAccessor.ui_node.get_node("%Starter").selected.connect(func(starter_value):
		starter = starter_value
	)
	UIAccessor.ui_node.get_node("%Horn").button_up.connect(_horn_state_changed.bind(false))
	UIAccessor.ui_node.get_node("%Horn").button_down.connect(_horn_state_changed.bind(true))

	UIAccessor.ui_node.get_node("%Bell").button_up.connect(_bell_state_changed.bind(false))
	UIAccessor.ui_node.get_node("%Bell").button_down.connect(_bell_state_changed.bind(true))

func _horn_state_changed(horn_state):
	$HornSoundPlayer3D.honking = horn_state

func _bell_state_changed(bell_state):
	$BellSoundPlayer3D.honking = bell_state
#	print(is_convergingv(true, 1, -1))
#	print(should_switchv(1, true, 1, false, false), 1)
#	print(should_switchv(-1, true, 1, false, false), 2)
#	print(should_switchv(1, true, 1, false, true), 3)
#	print(should_switchv(-1, true, 1, false, false), 4)
#	print(should_switchv(1, true, 1, true, false), 5)
#	print(should_switchv(-1, false, 1, false, false), 6)
#	print(should_switchv(-1, false, 1, false, false), 7)
#	print(should_switchv(-1, false, 1, false, false), 8)
#	print(should_switchv(-1, false, 1, false, false), 9)
	
	

func _on_area_3d_area_entered(area: Area3D):
	prints(area, area.is_in_group("switch"), "entering", in_switch_progress)
	if in_switch_progress:
		return
	if area.is_in_group("switch"):
		UIAccessor.ui_node.get_node("%Switch").disabled = false
		is_inside_switch_area = true
		switch_area = area
		print(should_switch())
		if is_converging():
			return
		if not should_switch():
			return
		if switch_area.disabled:
			call_deferred("switch_nodes")


func _on_area_3d_area_exited(area: Area3D):
	prints(area, area.is_in_group("switch"), "exiting", in_switch_progress)
	if in_switch_progress:
		return
	if area.is_in_group("switch"):
		UIAccessor.ui_node.get_node("%Switch").disabled = true
		is_inside_switch_area = false
		print_verbose(should_switch())
		if not is_converging():
			return
		if should_switch() and switch_area.disabled:
			call_deferred("switch_nodes")
		set_deferred("switch_area", "null")


func _input(event: InputEvent):
	if event is InputEventKey:
		if event.keycode == KEY_G and event.pressed and not event.echo:
			if is_instance_valid(switch_area) and not switch_area.disabled:
				switch_area.toggle_switch()
				switch_nodes()
	super(event)


func switch_nodes():
	# For reversing purposes
	print(is_converging(), "true")
	print("isthisreallytrue")
	if is_converging():
		switch_area.switch = !switch_area.switch
	var current_path = switch_area.current_path
	prints("thecurrentpath", current_path)
	# For reversing purposes, dont delete
	if is_converging():
		switch_area.switch = !switch_area.switch
	if get_parent() == current_path:
		in_switch_progress = false
		return
	in_switch_progress = true
	for node in get_tree().get_nodes_in_group('train_12505'):
		if node is PathFollow3D:
			node.reparent(current_path)
			node.progress = current_path.curve.get_closest_offset(node.global_position)
	in_switch_progress = false
	print("Switched successfully")


func is_convergingv(conv, sw_dir, dir):
	if dir == sw_dir:
		return conv
	else:
		return not conv

func should_switchv(dir, sw, sw_dir, loop_line, conv):
	if not conv:
		if sw:
#			return true
			if dir == sw_dir:
				return true
			elif dir == -sw_dir:
				return false
		return false
	elif conv:
		if loop_line:
			return true
		else:
			return false
		if sw:
			print("Train derailed!")
			return false  # derail
	return false

func is_converging():
	var direction = signi(velocity)
	if is_zero_approx(direction):
		return
	if not is_instance_valid(switch_area):
		return
	var conv = switch_area.converging # for forwards
	var sw_dir = switch_area.switch_direction
	prints(direction, conv, sw_dir, is_convergingv(conv, sw_dir, direction))
	return is_convergingv(conv, sw_dir, direction)
	# potential solution use * 2 - 1 formula with xor gate
		
func should_switch():
	var direction = signi(velocity)
	var switch = switch_area.switch
	if is_zero_approx(direction):
		print("Direction is zero")
		return
	if not is_instance_valid(switch_area):
		print("Switch area is valid")
		return
	var is_loop_line = get_parent() == switch_area.verging_path
	var switch_dir = switch_area.switch_direction
	prints("loop_line", is_loop_line)
	return should_switchv(direction, switch, switch_dir, is_loop_line, is_converging())
#	if not is_converging() and switch and direction == switch_dir:
#		return true
#	if not is_converging() and not switch and direction == switch_dir:
#		return false
#	if is_converging() and direction == switch_dir and is_loop_line:
#		return true
#	if is_converging() and direction == switch_dir and not is_loop_line:
#		return false
#	print("Should not reach this part")
#	prints(is_converging(), direction, switch_dir, is_loop_line)
#	return false
