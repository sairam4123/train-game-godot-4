extends Node3D
class_name Train3D

@export var consist_nps: Array[NodePath]

@export var train_info: TrainInfo

var engines: Array[BasicLocomotive3D]
var coaches: Array[BasicCoach3D]
var consist: Array

@export var engine_mass: float = 123.0 # tons
@export var coach_mass: float = 39.5  # tons

var throttle: float
var brakes: float
var reverser: int
var is_powered: bool

var velocity: float
var tractive_effort: float
var total_force: float
var acceleration: float
var momentum: float
var braking_force: float
var distance_travelled: float

# Called when the node enters the scene tree for the first time.
func _ready():
	for wagon in consist_nps.map(get_node):
		consist.append(wagon)
		wagon.set_train(self)
		if wagon is BasicLocomotive3D:
			engines.append(wagon)
		if wagon is BasicCoach3D:
			coaches.append(wagon)
	
#	for engine in engine_nps.map(get_node):
#		engines.append(engine)
#		engine.set_train(self)
#
#	for coach in coach_nps.map(get_node):
#		coaches.append(coach)
#		coach.set_train(self)
#


func get_train_consist() -> Array:
	return consist

func get_coaches() -> Array:
	return coaches

func get_engines() -> Array:
	return engines


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var speed_o_meter = UIAccessor.ui_node.get_node("%Speedometer")
	velocity = engines[0].velocity
	brakes = engines[0].brake
	#$EnginePhysics3D.engine_position = engines[0].global_position
	#$EnginePhysics3D.throttle = throttle
	#DebugPrint.add_text("Throttle: %.2f\n" % throttle)
	#$EnginePhysics3D.brake = brakes
	#DebugPrint.add_text("Brakes: %.2f\n" % brakes)
	#$EnginePhysics3D.rev = reverser
	#$EnginePhysics3D.is_powered = is_powered
	#$EnginePhysics3D.total_mass = engine_mass + (coach_mass * 22)
	#
	#velocity = $EnginePhysics3D.velocity
	#acceleration = $EnginePhysics3D.acceleration
	#tractive_effort = $EnginePhysics3D.tractive_effort
	#total_force = $EnginePhysics3D.total_force
	#momentum = $EnginePhysics3D.momentum
	#braking_force = $EnginePhysics3D.brake_force
	distance_travelled += velocity * delta
	speed_o_meter.speed = velocity * 3.6
	speed_o_meter.distance_covered = distance_travelled / 1000

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_Z and event.ctrl_pressed and event.pressed:
			distance_travelled = 0
		print("event")
