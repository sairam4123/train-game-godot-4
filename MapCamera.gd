
extends SubViewport


@onready var object = get_parent().find_child('PlayerLocomotive3D')

var follow_obj = false

func _ready():
	%DebugLayout/%ResetLoc.pressed.connect(_reset_location)
	%DebugLayout/%FollowLoc.toggled.connect(_follow_obj)

func _reset_location():
	$MapCamera.global_position.x = object.global_position.x
	$MapCamera.rotation.y = ((2 * PI)-0.001)-object.global_rotation.y
	$MapCamera.global_position.z = object.global_position.z

func _follow_obj(pressed):
	follow_obj = pressed
	if not pressed:
		$MapCamera.rotation.y = ((2 * PI)-0.001)+object.rotation.y

func _process(delta):
	if follow_obj:
		$MapCamera.global_position.x = object.global_position.x
		$MapCamera.rotation.y = ((2 * PI)-0.001)+object.global_rotation.y
		$MapCamera.global_position.z = object.global_position.z
