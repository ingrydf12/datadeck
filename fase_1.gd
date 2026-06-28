extends Node2D
@onready var cartas_container = HudCartas.get_node("./Cartas");
@onready var curva_mao = HudCartas.get_node("./CurvaMao");

const CARTA_SCENE = preload("res://screens/gameplay/Interactions/carta.tscn")
var fase: Phase
var _loading := false

func _ready() -> void:
	GameManager.state_changed.connect(_on_state_changed)

	if fase != null:
		_load_cards()

func setup(phase: Phase):
	fase = phase

	HudCartas.visible = true
	HudCartas.carregar_array_objetivo(fase.target_state)

	GameManager.history.clear()

	_load_cards()

	await get_tree().process_frame
	
# --------- ESTADOS -------------

func _on_state_changed(state: Array):
	$Array.carregar_estado_inicial(state)

	for carta: Carta in cartas_container.get_children():
		carta.atualizar_contexto(state)
		
func atualizar_array():
	var estado = GameManager.current_state

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

# --- INTERACAO COM AREA ACAO PARA ATUALIZAR O ARRAY
func _on_area_acao_mudar_array(carta:Carta):
	GameManager.apply_operation(carta)

	if carta.get_parent() == cartas_container:
		cartas_container.remove_child(carta)
	
func undo():
	if GameManager.history.is_empty():
		return

	var move: Move = GameManager.history.pop_back()

	$Array.carregar_estado_inicial(move.previous)
	var carta: Carta = move.card

	if carta:
		cartas_container.add_child(carta)
		carta.resetar_na_mao()
		curva_mao.organizar_cartas(
			cartas_container.get_children()
		)

	HudCartas.atualizar_historico(GameManager.history)

	await get_tree().process_frame
	atualizar_array()
