@tool
extends Control
class_name RotateCircleLabel


func _process(delta):
	queue_redraw()

func _draw():
	var default_font = ThemeDB.fallback_font
	var default_font_size = ThemeDB.fallback_font_size
	draw_arc(pivot_offset, 72, -PI, 0, 64, Color.RED)
	draw_arc(pivot_offset, 108, -PI, 0, 64, Color.RED)
