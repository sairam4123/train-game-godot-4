extends Node

var text = ""
var label: Label

func _ready():
	label = UIAccessor.ui_node.get_node("%DebugLabel")

func add_text(msg: String):
	text += msg

func _physics_process(delta):
	label.text = text
	text = ""
