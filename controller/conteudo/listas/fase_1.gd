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
	
# --------- ESTADOS -------------

func _on_state_changed(state:Array):
	$Array.atualizar_estado(state)

	for carta:Carta in cartas_container.get_children():
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

	for operacao in fase.available_cards:
		var carta: Carta = CARTA_SCENE.instantiate()

		carta.setup(operacao)
		cartas_container.add_child(carta)
		
	if curva_mao:
		curva_mao.organizar_cartas(
			cartas_container.get_children()
		)

	_loading = false

# --- INTERACOES QUE ALTERAM O ARRAY
func _on_area_acao_mudar_array(carta:Carta):
	GameManager.apply_operation(carta)

	if carta.get_parent() == cartas_container:
		cartas_container.remove_child(carta)

# TODO: Mover isso para game manager
func undo():
	if GameManager.history.is_empty():
		return

	var move: Move = GameManager.history.pop_back()

	GameManager.current_state = move.previous.duplicate(true)

	await $Array.carregar_estado_inicial(
		GameManager.current_state
	)

	var carta: Carta = move.card

	if carta:
		cartas_container.add_child(carta)
		carta.resetar_na_mao()

	curva_mao.organizar_cartas(
		cartas_container.get_children()
	)
	HudCartas.atualizar_historico(
		GameManager.history
	)
