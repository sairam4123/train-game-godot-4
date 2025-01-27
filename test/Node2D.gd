extends Node2D

var station_board_size = Vector2(500, 300)
var station_names = ["Station A", "Station B", "Station C", "Station D"]
var curve_points = []
var labels = []

# Returns the point on a Catmull-Rom spline defined by the four control points
# P0, P1, P2, and P3, and the interpolation factor t, where t is a value between
# 0 and 1 that represents how far between P1 and P2 to interpolate.
#
# The tension parameter determines the tightness of the curve. A higher value will
# result in a tighter curve. A value of 0.5 is generally a good starting point.
# The result is a Vector2 representing the interpolated point on the curve.
func interpolate_crspline(P0, P1, P2, P3, t, tension=0.5):
	var t2 = t * t
	var t3 = t2 * t
	var m0 = (P1 - P0) * (1 + tension) / 2.0
	var m0_dot5 = m0 / 2.0
	var m1 = (P2 - P1) * (1 + tension) / 2.0
	var m1_dot5 = m1 / 2.0
	var m2 = (P3 - P2) * (1 + tension) / 2.0
	var m2_dot5 = m2 / 2.0
	var a0 = 2 * t3 - 3 * t2 + 1
	var a1 = t3 - 2 * t2 + t
	var a2 = t3 - t2
	var a3 = -2 * t3 + 3 * t2
	return a0 * P1 + a1 * m0 + a2 * m1 - a3 * m1_dot5

func _ready():
	# Generate curve points based on station board size
	var curve_control_points = []
	curve_control_points.append(Vector2(-station_board_size.x / 2, station_board_size.y / 2))
	for i in range(len(station_names)):
		curve_control_points.append(Vector2(station_board_size.x / (len(station_names) - 1) * i - station_board_size.x / 2, station_board_size.y / 2))
	curve_control_points.append(Vector2(0, -station_board_size.y / 2))
	curve_control_points.append(Vector2(station_board_size.x / 2, station_board_size.y / 2))
	curve_points = []
	for i in range(curve_control_points.size() - 3):
		for j in range(10):
			curve_points.append(interpolate_crspline(curve_control_points[i], curve_control_points[i + 1], curve_control_points[i + 2], curve_control_points[i + 3], j / 10))
	
	# Create Control nodes with Label child for each station name and position them along the curve
	for i in range(len(station_names)):
		var label = Label.new()
		label.text = station_names[i]
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		var control = Control.new()
		control.add_child(label)
		add_child(control)
		labels.append(label)
		control.rect_size = label.rect_size
		
		# Set the curve for the control
		var curve = Curve2D.new()
		curve.set_points(curve_points)
		control.curve = curve
		
		# Position the Control node along the curve
		var position_on_curve = i / (len(station_names) - 1)
		var pos_on_curve = curve.interpolate(position_on_curve)
		control.rect_position = pos_on_curve - control.rect_size / 2
		
		# Adjust the position of the control to fit the station board size
		var control_pos = control.rect_position + station_board_size / 2
		control_pos.x = control_pos.x.floor()
		control_pos.y = control_pos.y.floor()
		control.rect_position = control_pos - station_board_size / 2
