extends Node3D

var is_inside_switch_area: bool = false
var switch_area: Switch3D
var in_switch_progress: bool = false

var owner_wagon

enum TrainDirection {
	FORWARD = 1,
	REVERSE = -1
}


# Called when the node enters the scene tree for the first time.
func _ready():
	owner_wagon = get_parent()
	if not (owner_wagon is BasicLocomotive3D or owner_wagon is BasicCoach3D):
		owner_wagon = null
		push_error("Owner is not an instance of BasicLocomotive3D or BasicCoach3D")


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

#		if sw:
#			print("Train derailed!")
#			return false  # derail


func _on_area_3d_area_entered(area):
	if in_switch_progress:
		return
	if not (area is Switch3D):
		return
	# the area is switch 3d
	switch_area = area
	is_inside_switch_area = true
	var is_conv = is_convergingv(switch_area.converging, signi(owner_wagon.velocity))
	if not is_conv:
		var can_sw = should_switchv(signi(owner_wagon.velocity), switch_area.switch, false, is_conv)
		if can_sw:
			call_deferred("switch")

func _on_area_3d_area_exited(area):
	if in_switch_progress:
		return
	if not (area is Switch3D):
		return
	
	is_inside_switch_area = false
	switch_area = area
	var is_conv = is_convergingv(switch_area.converging, signi(owner_wagon.velocity))
	var loop_line = switch_area.verging_path == get_parent().get_parent()
	prints(get_parent().name, "is on loop line: ", loop_line)
	if is_conv:
		var can_sw = should_switchv(signi(owner_wagon.velocity), switch_area.switch, loop_line, is_conv)
		if can_sw:
			call_deferred("switch")


func get_switching_path() -> Path3D:
	var is_conv = is_convergingv(switch_area.converging, signi(owner_wagon.velocity))
	var loop_line = false
	if is_conv:
		loop_line = switch_area.verging_path == get_parent().get_parent()
	var can_switch = should_switchv(signi(owner_wagon.velocity), switch_area.switch, loop_line, is_conv)
	if is_conv:
		return switch_area.main_path if can_switch else switch_area.verging_path
	return switch_area.verging_path if can_switch else switch_area.main_path


func switch():
	var switching_path = get_switching_path()
	var current_path = get_parent().get_parent()
	if current_path == switching_path:
		push_warning("Already switched!")
		return
	in_switch_progress = true
	get_parent().reparent(switching_path)
	get_parent().progress = switching_path.curve.get_closest_offset(get_parent().global_position)
	in_switch_progress = false
