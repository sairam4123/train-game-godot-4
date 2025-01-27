@tool
extends Node3D


@export var text: String = 'Tambaram':
	set(value):
		text = value
		_generate()

var _np
@export var node: NodePath:
	set(value):
		node = value
		_np = get_node(value)

func _ready():
	_np = get_node(node)

func _generate():
	for child in _np.get_children():
		_np.remove_child(child)
	print(text.length())
	for i in range(text.length()):
		var char = text[i]
		var lab = Label3D.new()
		lab.text = char
		lab.owner = get_tree().get_edited_scene_root()
		print(lab.text)
		_np.add_child(lab)
