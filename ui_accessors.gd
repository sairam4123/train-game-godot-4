extends Node

var ui_node: Node

func _ready():
	ui_node = get_tree().get_root().get_node("Game/%DebugLayout")

func play_audio_fade_in_apn(apn, duration: int = 1, volume: float = 100, tween = null):
	if not tween:
		tween = create_tween()
	var tweener = tween.parallel().tween_property(apn, "volume_db", linear_to_db((volume)/100.0), duration)
	tweener = tweener.from(linear_to_db(0.001)).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	return apn

func play_audio_fade_out_apn(apn, duration: int = 1, tween = null):
	if not tween:
		tween = create_tween()
	var tweener = tween.parallel().tween_property(apn, "volume_db", linear_to_db(0.001), duration)
	tweener = tweener.from_current().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	return apn

func play_audio_crossfade_apn(apn1, apn2, callback: Callable, volume: float = 6.25, duration: int = 1):
	var tween = create_tween()
	if apn2:
		apn2 = play_audio_fade_in_apn(apn2, duration, volume, tween)
	if apn1:
		apn1 = play_audio_fade_out_apn(apn1, duration, tween)
	tween.finished.connect(callback)
	return [apn1, apn2]
