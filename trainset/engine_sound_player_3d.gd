@tool
extends AudioStreamPlayer3D


signal engine_started
signal engine_stopped

@export var engine_startup: AudioStream
@export var engine_shutdown: AudioStream
@export var engine_idle: AudioStream

var is_engine_started = false
var _engine: BasicLocomotive3D

## [configurable]
@export var max_pitch: float = 2.1

## [configurable]
## Minimum idle pitch for the engine.
@export var min_pitch: float = 1.0

## [configurable]
## Safe tractive effort allowed may cause damage if the tractive surpasses this limit. Unit: kN
@export var max_tractive_force_allowed: float = 1.0

@export var action_engine_start: bool = false:
	set(_value):
		if is_engine_started:
			return
		stream = engine_startup
		play()
		action_engine_start = false

@export var action_engine_stop: bool = false:
	set(_value):
		if not is_engine_started:
			return
		stop()
		stream = engine_shutdown
		play()
		action_engine_stop = false

func _ready():
	_engine = get_parent()
	if not _engine is PathFollow3D:
		_engine = null
		push_error("Parent is not of type PathFollow3D")
	finished.connect(_on_player_finished)

func _on_player_finished():
	if stream == engine_startup:
		is_engine_started = true
		engine_started.emit()
		stream = engine_idle
		play()
	if stream == engine_shutdown:
		stream = null
		is_engine_started = false
		engine_stopped.emit()

func _physics_process(delta):
	if Engine.is_editor_hint():
		return
	
	if stream == engine_idle:
		var tract_force_kN = _engine.tractive_force / 1000
		var alpha = (max_pitch - min_pitch)/(max_tractive_force_allowed)
		var pitch = min_pitch * (1 + alpha * (tract_force_kN))
		pitch_scale += (pitch-pitch_scale) * delta
	else:
		pitch_scale = 1
