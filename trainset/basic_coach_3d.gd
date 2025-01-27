@tool
extends PathFollow3D
class_name BasicCoach3D

var is_looped = false
var direction_of_motion = 1:  # Train forwards
	get:
		if is_zero_approx(velocity):
			return 0
		return (velocity/abs(velocity)) * (-1 if is_looped else 1)
		## Note: Use signf() function?

# if is_inside_tree():
	#			var path = get_parent()
	#			return signi(velocity) * (-1 if path.reversed else 1) * (-1 if is_looped else 1)

@export_range(0, 1, 0.0001) var offset = 0.0:
	set(value):
		offset = value
		progress_ratio = offset

@export var mass: float = 1000

var train: Train3D

var velocity = 0:
	get:
		if is_inside_tree() and train:
			return train.velocity
		return 0

var brake = 0:
	get:
		if is_inside_tree() and train:
			return train.brakes
		return 0

func set_train(_train: Train3D):
	train = _train

@onready var camera_3d = %Camera3D
func get_camera():
	return camera_3d

func _physics_process(delta):
	if Engine.is_editor_hint():
		return
	var path = get_parent()
	progress += abs(velocity) * delta * direction_of_motion * (-1 if path.reversed else 1)
