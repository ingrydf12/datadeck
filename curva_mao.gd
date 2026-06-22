@tool
extends Path2D

@onready var line: Line2D = $Line2D

func _ready() -> void:
	if Engine.is_editor_hint():
		line.show()
	else:
		line.hide()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		if curve:
			line.points = curve.get_baked_points()

func get_filler_points(n_elements: int) -> Array[Transform2D]:
	var lista: Array[Transform2D] = []

	if curve == null:
		return lista

	if n_elements <= 0:
		return lista

	var tamanho = curve.get_baked_length()
	var espaco = tamanho / (n_elements + 1)

	for i in range(n_elements):

		var distancia = (i + 1) * espaco

		lista.append(
			curve.sample_baked_with_rotation(distancia)
		)

	return lista

func organizar_cartas(cartas: Array) -> void:
	if cartas.is_empty():
		return

	var transforms = get_filler_points(cartas.size())

	for i in range(min(cartas.size(), transforms.size())):
		var carta = cartas[i]

		if carta == null:
			continue

		var local_pos = transforms[i].get_origin()

		# converte do espaço do Path2D para espaço global
		var global_pos = to_global(local_pos)

		carta.global_position = global_pos
		carta.rotation = transforms[i].get_rotation()

		# atualiza posição de retorno da carta
		if carta.has_method("definir_origem"):
			carta.definir_origem()
		elif "origem" in carta:
			carta.origem = carta.global_position
			carta.rotacao_original = carta.rotation
