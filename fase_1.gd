extends Node2D
@onready var cartas_container = HudCartas.get_node("./Cartas");
@onready var curva_mao = HudCartas.get_node("./CurvaMao");

const CARTA_SCENE = preload("res://screens/gameplay/Interactions/carta.tscn")
var fase: Phase
var _loading := false

func _ready() -> void:
	if fase != null:
		_load_cards()
	pass

func setup(phase: Phase):
	fase = phase
	GameManager.current_stage = phase

	HudCartas.visible = true
	HudCartas.carregar_array_objetivo(fase.target_state)

	$Array.carregar_estado_inicial(fase.initial_state)
	GameManager.history.clear()

	_load_cards()

	await get_tree().process_frame
	atualizar_array()
	
# --------- ESTADOS -------------
func atualizar_array():
	var estado = $Array.get_state()

	for carta: Carta in cartas_container.get_children():
		carta.atualizar_contexto(estado)
	

func _load_cards():
	if fase == null or _loading:
		return

	_loading = true

	for child in cartas_container.get_children():
		child.queue_free()

	await get_tree().process_frame

	for operacao in fase.available_cards:
		var carta: Carta = CARTA_SCENE.instantiate()
		carta.setup(operacao)
		cartas_container.add_child(carta)

		print("Carta adicionada:", carta)
		print("Filhos do container:", cartas_container.get_child_count())
		
	await get_tree().process_frame

	if curva_mao:
		curva_mao.organizar_cartas(
			cartas_container.get_children()
		)

	_loading = false

func salvar_estado(operation: Operacao):
	var move := Move.create(
		$Array.get_state().duplicate(true),
		operation
	)

	GameManager.history.append(move)
	HudCartas.atualizar_historico(GameManager.history)

# --- INTERACAO COM AREA ACAO PARA ATUALIZAR O ARRAY
func _on_area_acao_mudar_array(carta: Carta):
	var operation := carta.dados

	salvar_estado(operation)

	match operation.tipo:
		Operacao.Tipo.POP:
			$Array.pop()

		Operacao.Tipo.PUSH:
			$Array.push(operation.elemento)

	cartas_container.remove_child(carta)
	HudCartas.adicionar_carta_historico(carta)
	atualizar_array()
	GameManager.validate_state($Array.get_state())
	
func undo():
	if GameManager.history.is_empty():
		return

	var move: Move = GameManager.history.pop_back()

	$Array.carregar_estado_inicial(move.previous)
	HudCartas.atualizar_historico(GameManager.history)

	await get_tree().process_frame
	atualizar_array()
