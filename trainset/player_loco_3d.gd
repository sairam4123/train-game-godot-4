extends BasicLocomotive3D
class_name PlayerLocomotive3D


func _ready():
	super()
	var debug_layout = UIAccessor.ui_node
#
#	debug_layout.get_node("%Reverser").value_changed.connect(func setter_rev(__rev):
#		_rev = __rev
#	)
#	debug_layout.get_node("%Reverser").value_changed.connect(func setter_rev(__rev):
#		_rev = __rev
#	)
#	debug_layout.get_node("%Reverser").value_changed.connect(func setter_rev(__rev):
#		_rev = __rev
#	)

	debug_layout.get_node("%Ignition").value_changed.connect(func setter(starter_value):
		ignition = starter_value
	)
	debug_layout.get_node("%Starter").selected.connect(func setter(starter_value):
		starter = starter_value
		print(starter_value)
	)
	debug_layout.get_node("%Horn").button_up.connect(_horn_state_changed.bind(false))
	debug_layout.get_node("%Horn").button_down.connect(_horn_state_changed.bind(true))

	debug_layout.get_node("%Bell").button_up.connect(_bell_state_changed.bind(false))
	debug_layout.get_node("%Bell").button_down.connect(_bell_state_changed.bind(true))

func _physics_process(delta):
	var debug_layout = UIAccessor.ui_node
		
	if train:
#		print('train')
		rev = debug_layout.get_node("%Reverser").value
		throttle = debug_layout.get_node("%Throttle").value/100.0
		brake = debug_layout.get_node("%Brake").value/100.0
	
	super(delta)
	
	if train:

		DebugPrint.add_text(name + " FPS: %d\n" % (Engine.get_frames_per_second()))
		DebugPrint.add_text(name + " DOM: %d\n" % (direction_of_motion))
		DebugPrint.add_text(name + " Speed: %.2f kmph\n" % (velocity * 3.6))
		var dist = train.distance_travelled
		var braking_force = $EnginePhysics3D.braking_force
		var F_tot = $EnginePhysics3D.total_force
		var acc = $EnginePhysics3D.acceleration
		var momentum = $EnginePhysics3D.momentum
		
		
		DebugPrint.add_text(name + " Total Force: %.2f kN\n" % (F_tot / 1000))
		DebugPrint.add_text(name + " Acceleration: %.2f kmphps\n" % (acc * 3.6))
		DebugPrint.add_text(name + " Momentum: %.2f tonne kmph\n" % (momentum * (3.6 / 1000)))
		DebugPrint.add_text(name + " Braking Force: %.2f kN\n" % (braking_force / 1000))
		#DebugPrint.add_text(name + " Tractive Effort: %.2f kN\n" % (tractive_effort / 1000))
		DebugPrint.add_text(name + " Distance Travelled: %.2f km\n" % (dist / 1000))
		DebugPrint.add_text(name + " Power: " + ("On" if (is_powered) else "Off") + "\n")
		DebugPrint.add_text(name + " Path Offset: %f\n" % progress)
		

func _input(event: InputEvent):
	if event is InputEventKey:
		
		rev = train.reverser
		throttle = train.throttle
		brake = train.brakes
		
		if event.keycode == KEY_W and event.pressed:
			rev += 1
		elif event.keycode == KEY_S and event.pressed:
			rev -= 1
		
		if event.keycode == KEY_D and event.pressed:
			throttle += 1/100.0
		elif event.keycode == KEY_A and event.pressed:
			throttle -= 1/100.0
		
		if event.keycode == KEY_APOSTROPHE and event.pressed:
			brake += 1/100.0
		elif event.keycode == KEY_SEMICOLON and event.pressed:
			brake -= 1/100.0
		
		rev = clampi(rev, -1, 1)
		throttle = clamp(throttle, 0, 1)
		brake = clamp(brake, 0, 1)
		
		
		var debug_layout = UIAccessor.ui_node
		debug_layout.get_node("%Reverser").value = rev
		debug_layout.get_node("%Throttle").value = throttle * 100
		debug_layout.get_node("%Brake").value = brake * 100
		

func _horn_state_changed(horn_state):
	$HornSoundPlayer3D.honking = horn_state

func _bell_state_changed(bell_state):
	$BellSoundPlayer3D.honking = bell_state
