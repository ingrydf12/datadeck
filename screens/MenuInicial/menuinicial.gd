extends Control

func _on_bnt_jogar_pressed() -> void:
	await CartaTransition.play_transition("res://screens/gameplay/Main.tscn")

func _on_bnt_creditos_pressed() -> void:
	pass # Replace with function body.

func _on_bnt_sair_pressed() -> void:
	get_tree().quit()
