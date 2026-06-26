extends CanvasLayer

signal carta_jogada(carta : Carta)

#var inverte = false

func _ready() -> void:
	pass

func _on_ajuda_tutorial_pressed() -> void:
	pass # Replace with function body.
func carregar_cartas_fase(cartas):
	pass

func propagar_carta(carta : Carta):
	carta_jogada.emit(carta)

func carregar_array_objetivo(arrayobj):
	const largura_sprite : int = 12
	const espacamento : int = 1
	
	for index in arrayobj:
		var regiao = Rect2((largura_sprite + espacamento) * index, 0, largura_sprite, 18)
		var node : TextureRect = $ArrayObjetivo/MarginContainer/VBoxContainer/HBoxContainer/Base.duplicate()
		node.visible = true
		node.texture = node.texture.duplicate()
		node.texture.region = regiao
		$ArrayObjetivo/MarginContainer/VBoxContainer/HBoxContainer.add_child(node)

#func _unhandled_input(event: InputEvent) -> void:
	#if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT and not inverte:
		#carregar_array_objetivo([0,1,2,3,4,5])
		#inverte = !inverte
	#elif inverte:
		#for c in $ArrayObjetivo/MarginContainer/HBoxContainer.get_children():
			#if c == $ArrayObjetivo/MarginContainer/HBoxContainer/Base: continue
			#$ArrayObjetivo/MarginContainer/HBoxContainer.remove_child(c)
		#inverte = !inverte
