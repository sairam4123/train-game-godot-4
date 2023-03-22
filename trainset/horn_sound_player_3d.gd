@tool
extends AudioStreamPlayer3D

signal honked_for(time)

var engine: BasicLocomotive3D
var start_time = 0

@export var loop_start = 0.16
@export var loop_horn_continuous_detection = 3.34
@export var loop_end = 3.38

@export var horn_stream: AudioStream
@export var honking = false:
	set(value):
		if value:
			stream = horn_stream
			play()
			start_time = int(Time.get_unix_time_from_system())
		elif !value:
			stop()
			play(loop_end)
			var current_time = int(Time.get_unix_time_from_system())
			honked_for.emit(current_time-start_time)
		honking = value

# Called when the node enters the scene tree for the first time.
func _ready():
	engine = get_parent()
	if not engine is BasicLocomotive3D:
		push_error("Parent should be engine!")
		engine = null

func _process(delta):
	if honking and get_playback_position() > loop_horn_continuous_detection:
		seek(loop_start)
		
