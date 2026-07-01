extends HBoxContainer



func adicionar_carta_na_mao(carta : Carta):
	var ancora = Control.new()
	ancora.custom_minimum_size = carta.custom_minimum_size
	ancora.size_flags_vertical = Control.SIZE_EXPAND
	add_child(ancora)
	carta.anchor_top = 0
	carta.anchor_left = 0.5
	carta.anchor_bottom = 1
	carta.anchor_right = 0.5
	ancora.add_child(carta)
	#carta.resetar_na_mao()
	

func remover_carta(carta : Carta):
	for ancora in get_children():
		var carta_filha = ancora.get_child(0)
		if carta_filha == carta:
			ancora.remove_child(carta)
			remove_child(ancora)
			break

func get_cartas():
	var arr : Array[Carta]
	for ancora in get_children():
		if ancora.get_child_count() > 0:
			arr.append(ancora.get_child(0))
	
	return arr
