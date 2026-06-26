@tool
extends Control

@onready var itens = $PanelContainer/Itens

signal invalid_operation(motivo : String)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		_organizar_posicoes()
	pass

func _organizar_posicoes():
	var contagem = 0
	for c : Filme in itens.get_children():
		c.indice = contagem
		contagem+=1

func pop():
	if itens.get_child_count() < 1:
		invalid_operation.emit("Array não pode")
		return false
	
	var filme = itens.get_child(-1)
	itens.remove_child(filme)
	return filme

func push(valor : int):
	var filme_novo = load("res://filme.tscn").instantiate()
	filme_novo.indice = itens.get_child_count()
	filme_novo.valor = valor
	itens.add_child(filme_novo)
