extends Path3D
class_name RailTrack3D

@export var station_nps: Array[NodePath]
var stations: Array[Station3D] = []
@export var switch_nps: Array[NodePath]
var switches: Array[Switch3D] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for station in station_nps.map(get_node):
		stations.append(station)
	for switch in switch_nps.map(get_node):
		switches.append(switch)
	print(stations, switches)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
