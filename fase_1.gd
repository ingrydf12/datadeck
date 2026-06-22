extends Node2D
@onready var cartas_container = $HUD/Cartas
@onready var curva_mao = $HUD/CurvaMao
const CARTA_SCENE = preload("res://screens/gameplay/Interactions/carta.tscn")
var fase: Phase
var _loading := false

# Fase 1: Listas (Bloco de conteúdo)

func setup(phase: Phase):
	fase = phase
	_load_cards()

func _ready():
	if fase != null:
		_load_cards()

func _load_cards():
	if fase == null or _loading:
		return
	_loading = true

	for child in cartas_container.get_children():
		child.queue_free()
	await get_tree().process_frame

	for tipo in fase.available_cards:
		var carta: Carta = CARTA_SCENE.instantiate()
		var op := Operacao.new()
		op.tipo = tipo
		carta.setup(op)
		cartas_container.add_child(carta)
	await get_tree().process_frame

	if curva_mao:
		curva_mao.organizar_cartas(
			cartas_container.get_children()
		)

	_loading = false
