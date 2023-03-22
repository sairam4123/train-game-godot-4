extends Node3D

@export var engine_node: BasicLocomotive3D

enum TrainDirection {
	FORWARD = 1,
	BACKWARD = -1
}

enum SwitchWay {
	MAIN = 0,
	VERGENT = 1
}

func _ready():
	var disp_node = UIAccessor.ui_node
	var f_slider: HSlider = disp_node.get_node("%ForwardSwitch")
	var b_slider: HSlider = disp_node.get_node("%BackwardSwitch")
	f_slider.value_changed.connect(_slider_value_changed.bind(TrainDirection.FORWARD))
	b_slider.value_changed.connect(_slider_value_changed.bind(TrainDirection.BACKWARD))

func is_convergingv(conv: bool, dir: int) -> bool:
	if dir == TrainDirection.FORWARD:
		return conv
	else:
		return not conv

func should_switchv(dir: int, sw: bool, loop_line: bool, conv: bool):
	if not conv:  # diverging
		return sw
	elif conv:  # converging
		return loop_line
	return false

func _slider_value_changed(value, dir):
	var saved_dir = dir
	dir = dir * engine_node.rev
	if is_zero_approx(dir):
		print("Parking detected, using the forward of the engine dir!")
		dir = saved_dir
	var path: RailTrack3D = engine_node.get_parent()
	var nearest_switch: Switch3D
	var _dist: float = INF
	for switch in path.switches:
		prints(
			engine_node.position.direction_to(switch.position).normalized().dot(engine_node.position.normalized()),
			engine_node.position.distance_to(switch.position)
		)
		var is_div = not is_convergingv(switch.converging, dir)
		if is_div:
			var dist = engine_node.position.distance_to(switch.position)
			if dist < _dist:
				_dist = dist
				nearest_switch = switch
	
	if nearest_switch:
		print("Switching!")
		nearest_switch.switch = (value == SwitchWay.VERGENT)
		
