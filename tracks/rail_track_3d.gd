extends Path3D
class_name RailTrack3D

@export var reversed: bool
@export var is_looper: bool = false

@export var station_nps: Array[NodePath]
var stations: Array[Station3D]

@export var switch_nps: Array[NodePath]
var _switches: Array[Switch3D] = []
var switches: Array[Switch3D] = []:
	get:
		if _switches.size() == switch_nps.size():
			return _switches
		else:
			if not is_inside_tree():
				return _switches
			_switches.clear()
			for switch in switch_nps.map(get_node):
				_switches.append(switch)
			return _switches
			

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
