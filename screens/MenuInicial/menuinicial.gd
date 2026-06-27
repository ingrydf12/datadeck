extends Control

@onready var title_animation: AnimatedSprite2D = $TextureRect3/AnimatedSprite2D

func _on_bnt_jogar_pressed() -> void:
	title_animation.play("title")
	await title_animation.animation_finished

	await CartaTransition.play_transition("res://screens/gameplay/Main.tscn")

func _on_bnt_creditos_pressed() -> void:
	pass # Replace with function body.

func _on_bnt_sair_pressed() -> void:
	get_tree().quit()
