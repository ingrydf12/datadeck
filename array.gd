@tool
extends Control

const FILME_SCENE := preload("res://models/filme.tscn")

signal invalid_operation(motivo: String)

@onready var itens: Control = $PanelContainer/Itens


func atualizar_estado(estado: Array) -> void:
	for filho in itens.get_children():
		filho.queue_free()

	await get_tree().process_frame

	for valor in estado:
		push(valor)


func carregar_estado_inicial(estado: Array) -> void:
	await atualizar_estado(estado)


func get_state() -> Array:
	var estado: Array = []

	for filme: Filme in itens.get_children():
		estado.append(filme.valor)

	return estado


func _organizar_posicoes() -> void:
	for i in itens.get_child_count():
		var filme: Filme = itens.get_child(i)
		filme.indice = i


func _criar_filme(valor: int) -> Filme:
	var filme: Filme = FILME_SCENE.instantiate()
	filme.valor = valor
	return filme


func _posicao_valida(posicao: int, permitir_final := false) -> bool:
	var limite := itens.get_child_count()

	if permitir_final:
		limite += 1

	if posicao < 0 or posicao >= limite:
		invalid_operation.emit("Posição inválida")
		return false

	return true


# Operações
func push(valor: int) -> void:
	var filme := _criar_filme(valor)

	itens.add_child(filme)

	_organizar_posicoes()


func pop() -> bool:
	if itens.get_child_count() == 0:
		invalid_operation.emit("Array vazio")
		return false

	var filme := itens.get_child(-1)

	itens.remove_child(filme)
	filme.queue_free()

	_organizar_posicoes()

	return true


func update(posicao: int, valor: int) -> bool:
	if !_posicao_valida(posicao):
		return false

	var filme: Filme = itens.get_child(posicao)
	filme.valor = valor

	return true


func insert(posicao: int, valor: int) -> bool:
	if !_posicao_valida(posicao, true):
		return false

	var filme := _criar_filme(valor)

	itens.add_child(filme)
	itens.move_child(filme, posicao)

	_organizar_posicoes()

	return true


func remove(posicao: int) -> bool:
	if !_posicao_valida(posicao):
		return false

	var filme := itens.get_child(posicao)

	itens.remove_child(filme)
	filme.queue_free()

	_organizar_posicoes()

	return true


func reverse() -> void:
	var estado := get_state()
	estado.reverse()

	await atualizar_estado(estado)


func sort() -> void:
	var estado := get_state()
	estado.sort()

	await atualizar_estado(estado)


func slice(inicio: int, fim: int) -> void:
	var estado := get_state().slice(inicio, fim)

	await atualizar_estado(estado)


func filter(valor: int) -> void:
	var estado: Array[int] = []

	for item in get_state():
		if item == valor:
			estado.append(item)

	await atualizar_estado(estado)


func map(valor: int) -> void:
	var estado: Array[int] = []

	for item in get_state():
		estado.append(item + valor)

	await atualizar_estado(estado)
