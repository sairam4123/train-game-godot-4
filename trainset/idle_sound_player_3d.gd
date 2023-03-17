@tool
extends AudioStreamPlayer3D

signal engine_started_up
signal engine_shut_down


@export var is_engine_stopped = true
@export var engine_start_initiated = false
@export var is_engine_idling = false
@export var engine_shutdown_initiated = false


## Pitch scale used when the engine is starting up
var initial_pitch_scale = 0.01
var idle_pitch_scale = 1
var current_pitch_scale = 1
## Pitch scale used when engine is shutting down
var final_pitch_scale = 0.01

@export var action_start_engine = false:
	set(value):
		if is_engine_idling or engine_start_initiated:
			return
		play(2.07)
		pitch_scale = initial_pitch_scale
		is_engine_stopped = false
		engine_start_initiated = true
		current_pitch_scale = idle_pitch_scale

@export var action_stop_engine = false:
	set(value):
		if (not is_engine_idling) or engine_shutdown_initiated:
			return
		engine_shutdown_initiated = true
		is_engine_idling = false
		current_pitch_scale = final_pitch_scale


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pitch_scale += (current_pitch_scale-pitch_scale) * delta
	var snapped_pitch_scale = snappedf(pitch_scale, 0.01)
	
	if is_equal_approx(snapped_pitch_scale, idle_pitch_scale) and engine_start_initiated:
		is_engine_idling = true
		engine_start_initiated = false
		engine_started_up.emit()
	
	if is_equal_approx(snapped_pitch_scale, final_pitch_scale) and engine_shutdown_initiated:
		engine_shutdown_initiated = false
		is_engine_stopped = true
		engine_shut_down.emit()
		
