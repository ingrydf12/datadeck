@tool
extends Control

@onready var itens = $PanelContainer/Itens

signal invalid_operation(motivo : String)

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		_organizar_posicoes()
	pass
	
func carregar_estado_inicial(initial_state: Array):
	print("Carregando:", initial_state)

	for item in itens.get_children():
		print("Removendo", item)
		item.queue_free()

	await get_tree().process_frame

	for valor in initial_state:
		push(valor)

	print("Quantidade:", itens.get_child_count())

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

func pop():
	if itens.get_child_count() < 1:
		invalid_operation.emit("Array não pode")
		return false
	
	var filme = itens.get_child(-1)
	itens.remove_child(filme)
	return filme

func push(valor:int):
	var filme_novo = load("res://filme.tscn").instantiate()
	filme_novo.valor = valor
	itens.add_child(filme_novo)

	_organizar_posicoes()
