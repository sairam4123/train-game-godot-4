extends Resource
class_name StationInfo

enum StationType {
	DEFAULT = 0,
	JUNCTION = 1,
	TERMINUS = 2
}

@export var name: String
@export var code: String
@export var type: StationType = StationType.DEFAULT
@export var platform: int = 4


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
