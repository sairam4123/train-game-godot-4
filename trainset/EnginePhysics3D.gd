extends Node3D


## Global
@export var power_output = 4740.0
@export var throttle_efficiency = 0.88
@export var engine_mass = 123.0
@export var coach_mass = 39.5 * 24

@export var frontal_area = 13
@export var grade_texture: FastNoiseLite


var g = 9.81
var Crr = 0.001
var Cd = 0.3
var rho = 1.29

## Per instance
var throttle = 0
var rev = -1
var brake = 0.0
var is_powered = true

## Out params
var velocity: float = 0
var total_force: float
var acceleration: float

## Debug params
var tractive_effort: float
var engine_force: float
var tractive_force: float
var brake_force: float
var resistive_force: float



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	_calculate_physics(delta)
	
func _calculate_physics(delta):
	var m = engine_mass + coach_mass
#	prints(velocity, throttle)
	## Resistive Constant (Aerodynamic Drag and Rolling resistance)
	tractive_effort = (throttle * power_output * throttle_efficiency * int(is_powered))
	engine_force = tractive_effort * rev
	resistive_force = -(0.5 * frontal_area * Cd * rho * velocity * abs(velocity)) + -(m * g * Crr * velocity)
	brake_force = (-brake * m * g * velocity)
	var theta = grade_texture.get_noise_2d(global_position.x, global_position.z)
	var grade_force = -(m * g * sin(theta * 0.01))
	total_force = engine_force + resistive_force + grade_force + brake_force
	acceleration = total_force / m
#	prints(engine_force, resistive_force, brake_force, total_force, acceleration)
	velocity += acceleration * delta
	tractive_force = clamp(abs(tractive_effort) - abs(resistive_force), 0, INF)


#
#	var debug_label = debug_layout.get_node("%DebugLabel")
#	velocity = snappedf(velocity, 0.0001)
#
#	DebugPrint.add_text("FPS: %s\n" % Engine.get_frames_per_second())
#	DebugPrint.add_text("Speed (in km/h): %.2f km/h\n" % abs(velocity * 3.6))
#	DebugPrint.add_text("Speed (in m/s): %.2f m/s\n" % abs(velocity))
#	var calculated_res_const = 0.5 * frontal_area * 0.5 * 1.29
#	DebugPrint.add_text("Aerodynamic Drag Constant: %.2f\n" % (calculated_res_const))
#	var tractive_effort = throttle * power_output * throttle_efficiency * int(is_powered)
#	var engine_force = tractive_effort * rev
#	var resistive_force = -calculated_res_const * velocity * abs(velocity) + -calculated_res_const*30 * velocity
#	var brake_force = (-brake * sign(velocity) * sqrt(abs(velocity)) * brake_efficiency * brake_friction)
#	var grade = grade_texture.get_noise_2d(position.x, position.z)
#	grade = remap(grade, -1, 1, -0.01, 0.01)
#	var grade_resistance = ((mass) * -9.81 * sin(grade))
#
#	DebugPrint.add_text("Grade Resistance (in kN): %.2f kN\n" % (grade_resistance / 1000))
#	total_force = engine_force + (resistive_force + grade_resistance) + brake_force
#	tractive_force = clampf(abs(tractive_effort) - abs(resistive_force), 0, INF)
#	var acc = total_force/(mass)
#	DebugPrint.add_text("Total Force (in kN): %.2f kN\n" % (total_force / 1000))
#	DebugPrint.add_text("Tractive Force (in kN): %.2f kN\n" % (engine_force / 1000))
#	DebugPrint.add_text("Tractive Effort (in kN): %.2f kN\n" % (tractive_effort / 1000))
#	DebugPrint.add_text("Tractive Force (engine only) (in kN): %.2f kN\n" % (tractive_force / 1000))
#	DebugPrint.add_text("Resistive Force (in kN): %.2f kN\n" % (resistive_force / 1000))
#	DebugPrint.add_text("Brake Force (in kN): %.2f kN\n" % (brake_force / 1000))
#	DebugPrint.add_text("Acceleration (in ms^-2): %.2f ms^-2\n" % (acc))
#	DebugPrint.add_text("Acceleration (in kmphps): %.2f kmphps\n" % (acc * 3.6))
#
#
#
#	velocity += acc * delta
##	var calculated_offset = (-0.0001 * exp(1) * randf_range(-1.0, 1.0) * abs(velocity)) * 0
##	real_offset += calculated_offset
#	DebugPrint.add_text("Real Offset (in m): %.2f mm\n" % (real_offset * 1000))
#	DebugPrint.add_text("Coupling Force (in N): %.2f mN\n" % ((offset-real_offset) * 1000))
#	DebugPrint.add_text("Power: " + ("On" if is_powered else "Off") + "\n")
#	progress += ((velocity) * delta)
