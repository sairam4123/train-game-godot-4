extends Node3D


## Global
@export var power_output = 4760.68
@export var throttle_efficiency = 1.0

@export var frontal_area = 13.41176
@export var grade_texture: FastNoiseLite



var g = 9.81
var Crr = 0.001
var Cd = 0.3
var rho = 1.29

## Input params
var wagon_position: Vector3
var total_mass: float = 10  # t
var throttle = 0.0
var rev = -1
var brake = 0.0
var is_powered = true
var brake_efficiency = 1.0
var braking_force = 259.876225 # kN
var coupling_force: float = 0
var starting_tractive_effort = 322.8 # kN

## Out params
var velocity: float = 0
var total_force: float
var acceleration: float
var tractive_effort: float
var momentum: float

## Debug params
var engine_force: float
var tractive_force: float
var brake_force: float
var resistive_force: float
var height: float = 0
var prev_momentum: float
var d_p: float



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	_calculate_physics(delta)

func _calculate_physics(delta):
	var m = total_mass * 1000
	var prev_momentum = momentum
	## Slope calculation
	var new_height = grade_texture.get_noise_2d(wagon_position.x, wagon_position.z)
	var dH = new_height-height
	var dS = velocity * delta
	var slope = atan2(dH,dS)
	DebugPrint.add_text(name + " Signed Velocity: %.2f\n" % min(velocity, signf(velocity)))
	DebugPrint.add_text(name + " Power Output: %.2f \n" % ((throttle * throttle_efficiency * power_output * int(is_powered) * 1000)))
	tractive_force = ((throttle * throttle_efficiency * power_output * int(is_powered) * 1000) / velocity if velocity > 1 else starting_tractive_effort * 1000)
	engine_force = tractive_force * rev
	## Resistive Forces Calculation (Aerodynamic Drag and Rolling Resistance)
	resistive_force = (-(0.5 * frontal_area * Cd * rho * velocity * abs(velocity)) + -(m * g * Crr * velocity))
	brake_force = (-brake * brake_efficiency * (braking_force * 1000) * min(velocity, signf(velocity)))
	
	var grade_force = -(m * g * sin(slope)) # *0 
	var forward_force = coupling_force if coupling_force else engine_force
	total_force = resistive_force + grade_force + brake_force + (d_p * delta) + forward_force
	acceleration = total_force / m
	height = new_height
#	prints(engine_force, resistive_force, brake_force, total_force, acceleration)
	velocity += acceleration * delta
	momentum = total_mass * velocity
	d_p = momentum - prev_momentum
	tractive_effort = clamp(abs(forward_force) - abs(resistive_force), 0, INF)

# AI Generated
#func calculate_physics(delta):
#	var m = total_mass
#
#	# Calculate resistive force
#	var speed = velocity.length()
#	var resistive_force = -(0.5 * frontal_area * Cd * rho * speed * speed) + -(m * g * Crr * speed)
#
#	# Calculate tractive force
#	var tractive_effort = (throttle * power_output * throttle_efficiency * int(is_powered))
#	var theta = grade_texture.get_noise_2d(engine_position.x, engine_position.z)
#	var grade_force = -(m * g * sin(theta * 0.01))
#	var tractive_force = tractive_effort + grade_force - resistive_force
#
#	# Calculate acceleration
#	var acceleration = tractive_force / m
#
#	# Update velocity and momentum
#	velocity = velocity + acceleration * delta
#	momentum = velocity * m
#
#	# Apply inertia
#	if is_on_track and momentum.length_squared() > 0:
#		var direction = momentum.normalized()
#		var max_speed = sqrt(2 * max_traction_force * wheel_radius / m)
#		var max_momentum = max_speed * m
#		var resistance = max_momentum * (1 - pow(speed / max_speed, 2))
#		momentum = momentum.slide(direction * tractive_force * delta, resistance * delta)
#
#	# Apply braking
#	if brake > 0:
#		var braking_force = brake * m * g
#		if velocity.length_squared() > 0:
#			var braking_direction = -velocity.normalized()
#			momentum = momentum.slide(braking_direction * braking_force * delta)
#
#	# Update position
#	position += velocity * delta

#My old code
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
