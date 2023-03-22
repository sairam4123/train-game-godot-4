@tool
extends Node3D

enum Mode {
	DIESEL = 0,
	ELECTRIC = 1
}

signal engine_started
signal engine_stopped

## Editor only
## Trick: use very small but 1 to trick godot into thinking it's a float but a int
@export_range(0, 100, 1.0000000001) var __current_throttle: float = 0

@export var mode: Mode = Mode.ELECTRIC

var _current_throttle: int:
	get:
		return int(__current_throttle)

@export var current_pitch: float = 1:
	get:
		return $IdleSoundPlayer3D.pitch_scale
## [configurable]

@export var max_pitch: float = 2.1

## [configurable]
## Minimum idle pitch for the engine.
@export var min_pitch: float = 1.0

## [configurable]
## Safe tractive effort allowed may cause damage if the tractive surpasses this limit. Unit: kN
@export var max_tractive_force_allowed: float = 8.0


## Autostart the engine when panto goes up (only if mode is electric)
@export_group("Electric")
@export var autostart = false
@export var action_panto_up = false:
	set(value):
		if not value:
			return
		if not is_inside_tree():
			return
		$PantoSoundPlayer3D.action_panto_up = true
		action_panto_up = false

@export var action_panto_down = false:
	set(value):
		if not value:
			return
		if not is_inside_tree():
			return
		$PantoSoundPlayer3D.action_panto_down = true
		action_panto_down = false
		
@export var action_start_engine = false:
	set(value):
		if not value:
			return
		if not is_inside_tree() or not $PantoSoundPlayer3D.is_panto_up:
			return
		$IdleSoundPlayer3D.action_start_engine = true
		action_start_engine = false

var _action_shutdown_engine = false:
	set(value):
		if not value:
			return
		if not is_inside_tree():
			return
		$IdleSoundPlayer3D.action_stop_engine = true
		_action_shutdown_engine = false


@export_group("Diesel")
@export var action_ignition_on = false
@export var action_ignition_off = false
@export var action_starter_on = false



var _engine: BasicLocomotive3D

func _ready():
	_engine = get_parent()
	if not _engine is PathFollow3D:
		_engine = null
		push_error("Parent is not of type PathFollow3D")


func _physics_process(delta):
	if Engine.is_editor_hint():
		var current_pitch = $IdleSoundPlayer3D.current_pitch_scale
		if $IdleSoundPlayer3D.is_engine_idling:
			var tract_force_kN = (_current_throttle / 12)
			var alpha = (1/min_pitch) * (max_pitch - min_pitch)/ (max_tractive_force_allowed)
			var pitch = min_pitch * (1 + alpha * (tract_force_kN))
			current_pitch += (pitch-current_pitch) * delta
		$IdleSoundPlayer3D.current_pitch_scale = current_pitch
		return
	
	var current_pitch = $IdleSoundPlayer3D.current_pitch_scale
	if $IdleSoundPlayer3D.is_engine_idling:
		var tract_force_kN = _engine.tractive_force / 1000
		var alpha = (max_pitch - min_pitch)/(max_tractive_force_allowed)
		var pitch = min_pitch * (1 + alpha * (tract_force_kN))
		current_pitch += (pitch-current_pitch) * delta
	$IdleSoundPlayer3D.current_pitch_scale = current_pitch


func _on_panto_sound_player_3d_panto_up_finalized():
	if autostart and mode == Mode.ELECTRIC:
		action_start_engine = true



#func _on_panto_sound_player_3d_panto_down_finalized():
#	if mode == Mode.ELECTRIC:
#		_action_shutdown_engine = true


func _on_idle_sound_player_3d_engine_started_up():
	engine_started.emit()


func _on_idle_sound_player_3d_engine_shut_down():
	engine_stopped.emit()


func _on_panto_sound_player_3d_panto_down_initialized():
	if mode == Mode.ELECTRIC:
		_action_shutdown_engine = true
