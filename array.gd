@tool
extends Control

@onready var itens = $PanelContainer/Itens

signal invalid_operation(motivo : String)

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		_organizar_posicoes()
	pass
	
func atualizar_estado(state: Array):
	for item in itens.get_children():
		item.queue_free()

	await get_tree().process_frame

	for valor in state:
		push(valor)

func _organizar_posicoes():
	var contagem = 0
	for c : Filme in itens.get_children():
		c.indice = contagem
		contagem+=1
		
func get_state() -> Array:
	var estado := []

	for filme: Filme in itens.get_children():
		estado.append(filme.valor)

	return estado

func carregar_estado_inicial(initial_state:Array):
	atualizar_estado(initial_state)

# --------- OPERACOES DE CARTAS NO ARRAY -----------
func pop():
	if itens.get_child_count() < 1:
		invalid_operation.emit("Array vazio")
		return false
	
	var filme = itens.get_child(-1)
	itens.remove_child(filme)
	filme.queue_free()

	_organizar_posicoes()

	return true

func push(valor: int):
	var filme_novo = load("res://models/filme.tscn").instantiate()
	filme_novo.valor = valor
	
	itens.add_child(filme_novo)

	_organizar_posicoes()


func update(posicao: int, valor: int):
	if posicao < 0 or posicao >= itens.get_child_count():
		invalid_operation.emit("Posição inválida")
		return false

	var filme: Filme = itens.get_child(posicao)
	filme.valor = valor

	return true


func insert(posicao: int, valor: int):
	if posicao < 0 or posicao > itens.get_child_count():
		invalid_operation.emit("Posição inválida")
		return false

	var filme_novo = load("res://models/filme.tscn").instantiate()
	filme_novo.valor = valor

	itens.add_child(filme_novo)
	itens.move_child(filme_novo, posicao)

	_organizar_posicoes()

	return true


func remove(posicao: int):
	if posicao < 0 or posicao >= itens.get_child_count():
		invalid_operation.emit("Posição inválida")
		return false

	var filme = itens.get_child(posicao)

	itens.remove_child(filme)
	filme.queue_free()

	_organizar_posicoes()

	return true


func reverse():
	var valores := get_state()
	valores.reverse()

	atualizar_estado(valores)


func sort():
	var valores := get_state()
	valores.sort()

	carregar_estado_inicial(valores)


func slice(inicio: int, fim: int):
	var valores := get_state()
	var novo_estado := valores.slice(inicio, fim)

	carregar_estado_inicial(novo_estado)


func filter(valor: int):
	var valores := get_state()
	var novo_estado := []

	for item in valores:
		if item == valor:
			novo_estado.append(item)

	carregar_estado_inicial(novo_estado)


func map(valor: int):
	var valores := get_state()
	var novo_estado := []

	for item in valores:
		novo_estado.append(item + valor)

	carregar_estado_inicial(novo_estado)
