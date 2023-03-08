@tool
extends AudioStreamPlayer3D

var engine

@export var loop_start = 0.16
@export var loop_horn_continuous_detection = 3.34
@export var loop_end = 3.38

@export var horn_stream: AudioStream
@export var honking = false:
	set(value):
		if value:
			stream = horn_stream
			play()
		elif !value:
			stop()
			play(loop_end)
		honking = value

# Called when the node enters the scene tree for the first time.
func _ready():
	engine = get_parent()
	if not engine is PathFollow3D:
		push_error("Parent should be engine!")
		engine = null

func _process(delta):
	if honking and get_playback_position() > loop_horn_continuous_detection:
		seek(loop_start)
		
