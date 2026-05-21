extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	distribuir_cartas()
	
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
	$Camera2D.global_position = get_global_mouse_position()
	
	


func distribuir_cartas():
	var filhos : Array[Node] = $Cartas.get_children()
	var pontos : Array[Transform2D] = $CurvaMao.get_filler_points(filhos.size())
	for i in range(filhos.size()):
		filhos[i].transform = pontos[i]
		filhos[i].position += $CurvaMao.global_position
		filhos[i].origem = filhos[i].global_position
		filhos[i].rotacao_original = filhos[i].rotation
		
		#filhos[i].rotation -= PI/2
