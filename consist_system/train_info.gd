extends Resource
class_name TrainInfo

enum TrainType {
	PASSENGER = 0,
	EXPRESS = 1,
	SUPERFAST_EXPRESS = 2,
	MAIL = 3,  # a special type of Indian Railways
	SPECIAL = 4
}

@export var number: int = 0
@export var name: String = ""
@export var type: TrainType = TrainType.PASSENGER
@export var from: StationInfo
@export var to: StationInfo

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
