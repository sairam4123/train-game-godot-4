extends Node3D

var vigilante_enabled = false
var max_horn_time = 120 # secs

var start_honked_time = 0

var vigilance = false
var engine: BasicLocomotive3D

func _ready():
	UIAccessor.ui_node.get_node("%Vigilante").pressed.connect(_vigilante_pressed)
	start_honked_time = int(Time.get_unix_time_from_system())
	engine = get_parent()
	if not engine is BasicLocomotive3D:
		engine = null
		push_error("parent is not of type BasicLocomotive3D")

func _process(delta):
	if not vigilante_enabled:
		return
	var current_time = int(Time.get_unix_time_from_system())
	if (current_time - start_honked_time) > max_horn_time and not vigilance:
		UIAccessor.ui_node.get_node("%Vigilante").disabled = false  # hack
		engine.ignition = false
		UIAccessor.ui_node.get_node("%Ignition").value = 0  # hack
		engine.brake = 1
		UIAccessor.ui_node.get_node("%Brake").value = engine.brake * 100  # hack
		UIAccessor.ui_node.get_node("%Ignition").editable = false  # hack
		vigilance = true
		print("Out of Control, braking!")

func _vigilante_pressed():
	start_honked_time = int(Time.get_unix_time_from_system())
	var pressed = UIAccessor.ui_node.get_node("%Vigilante").button_pressed
	if pressed:
		UIAccessor.ui_node.get_node("%Ignition").editable = true
		print("Vigilanted! I AM ACTIVE!")
		vigilance = not pressed
		UIAccessor.ui_node.get_node("%Vigilante").disabled = true

func _on_player_locomotive_3d_honked(time):
	print("Horn pressed, reset!")
	start_honked_time = int(Time.get_unix_time_from_system())

func _on_engine_sound_player_3d_engine_started():
	start_honked_time = int(Time.get_unix_time_from_system())

	
