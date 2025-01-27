@tool
extends Control

@export var max_speed = 200.0:
	set(val):
		max_speed = val
		if is_inside_tree():
			$TextureRect/TextureProgressBar.max_value = max_speed

@export var min_speed = 0.0:
	set(val):
		max_speed = val
		if is_inside_tree():
			$TextureRect/TextureProgressBar.min_value = min_speed


@export var speed = 89.0:
	set(val):
		speed = val
		if is_inside_tree():
			$TextureRect/TextureProgressBar.value = speed
			$Label.text = "%03d" % speed
			
@export var distance_covered = 0:
	set(val):
		distance_covered = val
		if is_inside_tree():
			$Label3.text = "%06d" % distance_covered
			
