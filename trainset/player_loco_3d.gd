extends BasicLocomotive3D
class_name PlayerLocomotive3D


func _ready():
	super()
	
	UIAccessor.ui_node.get_node("%Ignition").value_changed.connect(func(starter_value):
		ignition = starter_value
	)
	UIAccessor.ui_node.get_node("%Starter").value_changed.connect(func(starter_value):
		starter = starter_value
	)
	UIAccessor.ui_node.get_node("%Horn").button_up.connect(_horn_state_changed.bind(false))
	UIAccessor.ui_node.get_node("%Horn").button_down.connect(_horn_state_changed.bind(true))

	UIAccessor.ui_node.get_node("%Bell").button_up.connect(_bell_state_changed.bind(false))
	UIAccessor.ui_node.get_node("%Bell").button_down.connect(_bell_state_changed.bind(true))

func _input(event: InputEvent):
	if event is InputEventKey:
		if event.keycode == KEY_W and event.pressed:
			rev += 1
			rev = clampi(rev, -1, 1)
		elif event.keycode == KEY_S and event.pressed:
			rev -= 1
			rev = clampi(rev, -1, 1)
		if event.keycode == KEY_D and event.pressed:
			throttle += 1/100.0
		elif event.keycode == KEY_A and event.pressed:
			throttle -= 1/100.0
		if event.keycode == KEY_APOSTROPHE and event.pressed:
			brake += 1/100.0
		elif event.keycode == KEY_SEMICOLON and event.pressed:
			brake -= 1/100.0
		var debug_layout = UIAccessor.ui_node
		debug_layout.get_node("%Reverser").value = rev
		debug_layout.get_node("%Throttle").value = throttle * 100
		debug_layout.get_node("%Brake").value = brake * 100
		

func _horn_state_changed(horn_state):
	$HornSoundPlayer3D.honking = horn_state

func _bell_state_changed(bell_state):
	$BellSoundPlayer3D.honking = bell_state
