@tool
extends AudioStreamPlayer3D

signal panto_up_finalized
signal panto_up_initialized
signal panto_down_finalized
signal panto_down_initialized

@export var is_panto_up: bool = false
var is_panto_state_changing: bool = false

@export var panto_up: AudioStream
@export var panto_down: AudioStream

@export var action_panto_up: bool = false:
	set(_value):
		if is_panto_up or is_panto_state_changing:
			return
		panto_up_initialized.emit()
		is_panto_state_changing = true
		stream = panto_up
		play()
		action_panto_up = false

@export var action_panto_down: bool = false:
	set(_value):
		if is_panto_state_changing or (not is_panto_up):
			return
		panto_down_initialized.emit()
		is_panto_state_changing = true
		stream = panto_down
		play()
		action_panto_down = false


func _on_finished():
	if stream == panto_up:
		is_panto_up = true
		is_panto_state_changing = false
		panto_up_finalized.emit()
	if stream == panto_down:
		is_panto_up = false
		is_panto_state_changing = false
		panto_down_finalized.emit()
