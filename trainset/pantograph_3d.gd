@tool
extends MeshInstance3D

@export var up_position: float = 2.85
@export var up_duration: float = 8.70
@export var down_duration: float = 5.07
@export var down_position: float = 1.585
@export var up_delay: float = 2.08
@export var down_delay: float = 0.05
@export var is_up: bool = false:
	set(value):
		var tween
		if value:
			# play animation up
			tween = get_tree().create_tween()
			(tween.tween_property(
				self, 
				"position:y", 
				up_position, 
				up_duration
			)
			.from(down_position)
			.set_delay(up_delay)
			.set_trans(Tween.TRANS_ELASTIC)
		)
		elif not value:
			# play animation down
			tween = get_tree().create_tween()
			(
				tween.tween_property(
					self, 
					"position:y", 
					down_position, 
					down_duration
				)
				.from(up_position)
				.set_delay(down_delay)
				.set_trans(Tween.TRANS_ELASTIC))
		is_up = value
