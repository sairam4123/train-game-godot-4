@tool
extends PathFollow3D
class_name BasicCoach3D

@export_range(0, 1, 0.0001) var offset = 0.0:
	set(value):
		offset = value
		progress_ratio = offset

@export var mass: float = 1000

@export var engine: PathFollow3D:
	set(value):
		engine = value

var velocity = 0:
	get:
		if is_inside_tree():
			return engine.velocity

var brake = 0:
	get:
		if is_inside_tree():
			return engine.brake

func _physics_process(delta):
	if Engine.is_editor_hint():
		return
	progress += velocity * delta
