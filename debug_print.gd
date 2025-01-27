extends Node

var text = ""
var label: Label

func _ready():
	if UIAccessor.ui_node:
		label = UIAccessor.ui_node.get_node_or_null("%DebugLabel")

func add_text(msg: String):
	text += msg

func _physics_process(delta):
	label.text = text
	text = ""
