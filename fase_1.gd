extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#distribuir_cartas()
	
	#for carta in $Cartas.get_children():
		#var texto : Label = Label.new()
		#texto.text = carta.descricao
		#
		#var cb = func (): 
			#texto.position = carta.position
			#texto.rotation = carta.rotation
			#texto.scale = carta.scale
			#print("oi")
		#
		#carta.connect('draw', cb)
		#
		#$Textos.add_child(texto)
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#var lower_lim = Vector2($Camera2D.limit_left,$Camera2D.limit_top)
	#var upper_lim = Vector2($Camera2D.limit_right,$Camera2D.limit_bottom)
	var meio = Vector2(740, 500)
	var lower_lim = meio - Vector2(70,180)
	var upper_lim = meio + Vector2(50,100)
	$Camera2D.global_position = get_global_mouse_position().clamp(lower_lim, upper_lim)
	pass
	
	


#NAO PRECISA MAIS, É AUTOMATICO NO EDITOR

#func distribuir_cartas():
	#var filhos : Array[Node] = $Cartas.get_children()
	#var pontos : Array[Transform2D] = $CurvaMao.get_filler_points(filhos.size())
	#for i in range(filhos.size()):
		#filhos[i].transform = pontos[i]
		#filhos[i].position += $CurvaMao.global_position
		#filhos[i].origem = filhos[i].global_position
		#filhos[i].rotacao_original = filhos[i].rotation
		
		#filhos[i].rotation -= PI/2
