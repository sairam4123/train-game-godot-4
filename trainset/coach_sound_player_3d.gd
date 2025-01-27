@tool
extends AudioStreamPlayer3D

var coach
@export var speed_sounds_dict: Dictionary = {}
@export var squealing_stream: AudioStream
@export var braking_requirement: float = -0.0001

var prev_speed = 0

var current_apn = null
var transition_apn = null

func _ready():
	coach = get_parent()
	if not coach is PathFollow3D:
		push_error("Coach is not of type PathFollow3D")
		coach = null
	stream = squealing_stream
	

func _physics_process(delta):
	if Engine.is_editor_hint():
		return
	var speed = abs(coach.velocity) * 3.6 # convert into kmph
	var debug_layout = UIAccessor.ui_node
	DebugPrint.add_text(name +" Del Speed (in m): %.5f m\n" % (speed - prev_speed))
	if ((speed - prev_speed) < (braking_requirement)) and not is_zero_approx(coach.brake):
		if not playing:
			play()
	else:
		if playing:
			stop()
	var new_apn = get_audio_for_speed(speed)
	if new_apn != current_apn:
		print("Switching from: %s to %s" % [current_apn, new_apn])
		if new_apn:
			new_apn.play()
		await get_tree().create_timer(0.25).timeout
		
		UIAccessor.play_audio_crossfade_apn(current_apn, new_apn, (func crossfade_callback(apn):
			print("Callback called!")
			prints(current_apn, new_apn, apn)
			await get_tree().create_timer(0.25).timeout
			if apn and (not apn == current_apn):
				apn.stop()
		).bind(current_apn))
		current_apn = new_apn

	
	prev_speed = speed
	

func get_audio_for_speed(speed: float):
	speed = snappedf(speed, 0.001)
	if speed < 0.15:
		return null
	var speed_keys = speed_sounds_dict.keys()
	for speed_vec in speed_keys:
		if speed_vec.x < speed and speed < speed_vec.y:
			var audio = speed_sounds_dict[speed_vec]
			if audio:
				return get_node(audio)
			else:
				return current_apn
	return current_apn
			
