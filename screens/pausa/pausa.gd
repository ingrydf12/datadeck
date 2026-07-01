extends CanvasLayer

func _ready() -> void:
	layer = 100
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS

func open() -> void:
	get_tree().paused = true
	show()

func close() -> void:
	get_tree().paused = false
	hide()

func _on_retornar_pressed() -> void:
	close()

func _on_menu_pressed() -> void:
	get_tree().paused = false
	visible = false;
	HudCartas.hide()
	await CartaTransition.play_transition("res://screens/MenuInicial/menuinicial.tscn")

func _on_resetar_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
