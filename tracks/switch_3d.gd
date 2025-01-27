@tool
extends Area3D
class_name Switch3D

@export var switched_color = Color.BLUE_VIOLET
@export var switch_color = Color.GREEN_YELLOW
@export var main_path: Path3D
@export var verging_path: Path3D
@export var disabled: bool = false
@export var is_looper: bool = false
@export var looper_div_switch: Switch3D
@export var switch: bool = false:
	set(val):
		switch = val
		if is_inside_tree():
			var mat = ($MeshSwitchViewer3D.material_override as StandardMaterial3D)
			mat.albedo_color = switched_color if switch else switch_color
			mat.albedo_color.a8 = 140
			$MeshSwitchViewer3D.material_override = mat

@export var converging: bool = false:
	get:
		return converging


var invert: bool = false

@export var switch_direction: int = 1:
	set(value):
		if value in [-1, 1]:
			switch_direction = value
		else:
			return

# Called when the node enters the scene tree for the first time.
func _ready():
	var mat = ($MeshSwitchViewer3D.material_override as StandardMaterial3D)
	mat.albedo_color = switched_color if switch else switch_color
	mat.albedo_color.a8 = 140
	$MeshSwitchViewer3D.material_override = mat

func toggle_switch():
	if not Engine.is_editor_hint() and disabled:
		return
	self.switch = !switch

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if switch:
		$Label3D.text = "Switched\n" + "|\n".repeat(10).rstrip('\n')
	else:
		$Label3D.text = "Not Switched\n" + "|\n".repeat(10).rstrip('\n')

func _on_input_event(camera, event, _position, normal, shape_idx):
	print(camera)
	if camera.name == "MapCamera":
		if event is InputEventMouseButton:
			if event.button_mask & MOUSE_BUTTON_LEFT == MOUSE_BUTTON_LEFT:
				self.switch = !switch
