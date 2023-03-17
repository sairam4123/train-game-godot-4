@tool
extends PathFollow3D
class_name BasicLocomotive3D

# Overview:
## Basic Locomotive 3D is the basic implementation of Locomotive in OpenSkyTrainSim.
##
## Currently BasicLocomotive3D has the player functionality which will be moved to [PlayerLocomotive3D]
# Description ^^^^^

var throttle = 0
var rev: int = 1
var velocity = 0
var brake = 0

@export var power_output = 10000.0
@export var throttle_efficiency = 0.89
@export var brake_efficiency = 0.78
@export var brake_friction = 5000.0
@export var mass = 1000000.0
## The frontal area of the train used for aerodynamics calculation.
@export var frontal_area = 10
@export var grade_texture: FastNoiseLite
var total_force
var tractive_force

@export_range(0, 1, 0.0001) var offset = 0.0:
	set(value):
		offset = value
		progress_ratio = offset
var real_offset = 0

enum PowerMode {
	starter = 0,
	ignition = 1
}
var starter: bool = false:
	set(value):
		starter = value
		power_state_changed(starter, PowerMode.starter)

var ignition: bool = false:
	set(value):
		ignition = value
		power_state_changed(ignition, PowerMode.ignition)

var honking = false:
	set(value):
		honking = value
		$HornSoundPlayer3D.honking = honking
		
var bell_pressed = false:
	set(value):
		bell_pressed = value
		$BellSoundPlayer3D.honking = bell_pressed

var is_powered: bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	real_offset = offset
	if Engine.is_editor_hint():
		return
	$EngineSoundPlayer3D.engine_started.connect(_power_state_changed.bind(true))
	$EngineSoundPlayer3D.engine_stopped.connect(_power_state_changed.bind(false))
	
#	UIAccessor.ui_node.get_node("%Power").toggled.connect(_power_state_changed)
#	UIAccessor.ui_node.get_node("%Horn").button_up.connect(_horn_state_changed.bind(false))
#	UIAccessor.ui_node.get_node("%Horn").button_down.connect(_horn_state_changed.bind(true))
#
#	UIAccessor.ui_node.get_node("%Bell").button_up.connect(_bell_state_changed.bind(false))
#	UIAccessor.ui_node.get_node("%Bell").button_down.connect(_bell_state_changed.bind(true))

#func _horn_state_changed(horn_state):
#	$HornSoundPlayer3D.honking = horn_state
#
#func _bell_state_changed(bell_state):
#	$BellSoundPlayer3D.honking = bell_state

func _power_state_changed(power_state):
	is_powered = power_state

func power_state_changed(changed_value, power_mode):
	match power_mode:
		PowerMode.ignition:
			if changed_value:
				$EngineSoundPlayer3D.action_panto_up = true
				$Pantograph.is_up = true
			if not changed_value:
				$EngineSoundPlayer3D.action_panto_down = true
				$Pantograph.is_up = false
		PowerMode.starter:
			if ignition and changed_value:
				$EngineSoundPlayer3D.action_start_engine = true
			if not changed_value:
				return
#	match starter_state:
#		StarterState.START:
#			$EngineSoundPlayer3D.action_engine_start = true
#		StarterState.STOP:
#			$EngineSoundPlayer3D.action_engine_stop = true
#		StarterState.DEFAULT:
#			return
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Engine.is_editor_hint():
		return
	var debug_layout = UIAccessor.ui_node
	rev = debug_layout.get_node("%Reverser").value
	throttle = debug_layout.get_node("%Throttle").value/100.0
	brake = debug_layout.get_node("%Brake").value/100.0
	var res_const = debug_layout.get_node("%ResConst").value
	
	var debug_label = debug_layout.get_node("%DebugLabel")
	velocity = snappedf(velocity, 0.0001)
	debug_label.text = ""
	debug_label.text += "FPS: %s\n" % Engine.get_frames_per_second()
	debug_label.text += "Speed (in km/h): %.2f km/h\n" % abs(velocity * 3.6)
	debug_label.text += "Speed (in m/s): %.2f m/s\n" % abs(velocity)
	var calculated_res_const = 0.5 * frontal_area * 0.5 * 1.29
	debug_label.text += "Aerodynamic Drag Constant: %.2f\n" % (calculated_res_const)
	var tractive_effort = throttle * power_output * throttle_efficiency * int(is_powered)
	var engine_force = tractive_effort * rev
	var resistive_force = -calculated_res_const * velocity * abs(velocity) + -calculated_res_const*30 * velocity
	var brake_force = (-brake * sign(velocity) * sqrt(abs(velocity)) * brake_efficiency * brake_friction)
	var grade = grade_texture.get_noise_2d(position.x, position.z)
	grade = remap(grade, -1, 1, -0.01, 0.01)
	var grade_resistance = ((mass) * -9.81 * sin(grade))
	
	debug_label.text += "Grade Resistance (in kN): %.2f kN\n" % (grade_resistance / 1000)
	total_force = engine_force + (resistive_force + grade_resistance) + brake_force
	tractive_force = clampf(abs(tractive_effort) - abs(resistive_force), 0, INF)
	var acc = total_force/(mass)
	debug_label.text += "Total Force (in kN): %.2f kN\n" % (total_force / 1000)
	debug_label.text += "Tractive Force (in kN): %.2f kN\n" % (engine_force / 1000)
	debug_label.text += "Tractive Effort (in kN): %.2f kN\n" % (tractive_effort / 1000)
	debug_label.text += "Tractive Force (engine only) (in kN): %.2f kN\n" % (tractive_force / 1000)
	debug_label.text += "Resistive Force (in kN): %.2f kN\n" % (resistive_force / 1000)
	debug_label.text += "Brake Force (in kN): %.2f kN\n" % (brake_force / 1000)
	debug_label.text += "Acceleration (in ms^-2): %.2f ms^-2\n" % (acc)
	debug_label.text += "Acceleration (in kmphps): %.2f kmphps\n" % (acc * 3.6)
	

	
	velocity += acc * delta
#	var calculated_offset = (-0.0001 * exp(1) * randf_range(-1.0, 1.0) * abs(velocity)) * 0
#	real_offset += calculated_offset
	debug_label.text += "Real Offset (in m): %.2f mm\n" % (real_offset * 1000)
	debug_label.text += "Coupling Force (in N): %.2f mN\n" % ((offset-real_offset) * 1000)
	debug_label.text += "Power: " + ("On" if is_powered else "Off")
	progress += ((velocity) * delta) #  + (
#		(offset-real_offset)
#		)
#	real_offset += (offset-real_offset)
	
#
	

# RES_CONST = -0.4257, 12.8
