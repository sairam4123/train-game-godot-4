@tool
extends PathFollow3D
class_name BasicLocomotive3D

# Overview:
## Basic Locomotive 3D is the basic implementation of Locomotive in OpenSkyTrainSim.
##
## Currently BasicLocomotive3D has the player functionality which will be moved to [PlayerLocomotive3D]
# Description ^^^^^

signal honked(time)
signal belled(time)

var throttle = 0
var rev: int = 1
var velocity = 0
var brake = 0
var is_looped = false
var direction_of_motion = 1:  # Train forwards
	get:
		if is_zero_approx(velocity):
			return 0
		return (velocity/abs(velocity)) * (-1 if is_looped else 1)
			#  ^^^^^^^^^^^^^^^^^^^^^^^^ --> sign func
var train: Train3D

@export var power_output = 10000.0
@export var throttle_efficiency = 0.89
@export var brake_efficiency = 0.78
@export var brake_friction = 5000.0
@export var mass = 1000000.0
## The frontal area of the train used for aerodynamics calculation.
@export var frontal_area = 10
@export var grade_texture: FastNoiseLite
var total_force
var tractive_effort = 0

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

func set_train(_train: Train3D):
	train = _train

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

	$EnginePhysics3D.throttle = throttle
	$EnginePhysics3D.rev = rev
	$EnginePhysics3D.brake = brake
	$EnginePhysics3D.is_powered = is_powered
	
	tractive_effort = $EnginePhysics3D.tractive_effort
	velocity = $EnginePhysics3D.velocity
	total_force = $EnginePhysics3D.total_force
	progress += abs(velocity) * delta * direction_of_motion * (-1 if get_parent().reversed else 1)


#  + (
#		(offset-real_offset)
#		)
#	real_offset += (offset-real_offset)

# RES_CONST = -0.4257, 12.8

@onready var camera_3d = %Camera3D

func get_camera():
	return camera_3d


func _on_horn_sound_player_3d_honked_for(time):
	honked.emit(time)


func _on_bell_sound_player_3d_honked_for(time):
	belled.emit(time)
