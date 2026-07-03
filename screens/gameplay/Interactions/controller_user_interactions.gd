class_name GameplayHUD
extends CanvasLayer

var sound_error : AudioStream = preload("res://sounds/negative.wav")
var sound_swipe : AudioStream = preload("res://sounds/swipe.wav")

enum Audios {
	ERR,
	SWIPE
}

signal undo_pressed
signal pause_pressed
signal tutorial_pressed

func _on_undo_pressed() -> void:
	if GameManager.history.is_empty():
		play_sound(Audios.ERR)
		return
	else:
		play_sound(Audios.SWIPE, true)
	undo_pressed.emit()	

func _on_pause_pressed() -> void:
	pause_pressed.emit()

func _on_tutorial_pressed() -> void:
	tutorial_pressed.emit()

#sons de UI talvez devessem estar em singleton?
func play_sound(audio : Audios, force : bool = false):	
	if $AudioStreamPlayer.playing:
		if force:
			$AudioStreamPlayer.stop()
		else:
			return

	$AudioStreamPlayer.pitch_scale = randf_range(0.9, 1.1)
	
	match audio:
		Audios.ERR: 
			$AudioStreamPlayer.stream = sound_error
			$AudioStreamPlayer.play()
		Audios.SWIPE:
			$AudioStreamPlayer.stream = sound_swipe
			$AudioStreamPlayer.play()
