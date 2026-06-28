class_name GameplayHUD
extends CanvasLayer

signal undo_pressed
signal pause_pressed
signal tutorial_pressed

func _on_undo_pressed() -> void:
	undo_pressed.emit()

func _on_pause_pressed() -> void:
	pause_pressed.emit()

func _on_tutorial_pressed() -> void:
	tutorial_pressed.emit()
