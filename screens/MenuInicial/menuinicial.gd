extends Control

@onready var title_animation: AnimatedSprite2D = $Animation

func _on_bnt_jogar_pressed() -> void:
	$SubViewportContainer/SubViewport/CanvasLayer/VBoxContainer.mouse_behavior_recursive = MOUSE_BEHAVIOR_DISABLED
	
	title_animation.play("title")
	await title_animation.animation_finished

	await CartaTransition.play_transition("res://screens/gameplay/Main.tscn")
	
	

func _on_bnt_creditos_pressed() -> void:
	$Creditos.show()

func _on_bnt_sair_pressed() -> void:
	get_tree().quit()
