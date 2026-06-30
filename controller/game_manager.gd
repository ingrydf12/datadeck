extends Node

signal state_changed(state: Array)
signal stage_loaded(stage: Phase)
signal stage_completed(stage: Phase)
signal history_changed(history: Array[Move])

var stages: Array[Phase] = []
var current_stage_index: int = 0
var current_stage: Phase

var current_state: Array = []
var history: Array[Move] = []

func _ready():
	stages = Phase.build_all_stages()

# ---- CONTROLES E VALIDACAO DE FASE
func load_stage(index: int):
	if index < 0 or index >= stages.size():
		return

	current_stage_index = index
	current_stage = stages[index]

	current_state = current_stage.initial_state.duplicate(true)

	history.clear()
	history_changed.emit(history)

	stage_loaded.emit(current_stage)
	state_changed.emit(current_state)

func apply_operation(carta: Carta):
	if carta.dados == null:
		return

	if !carta.dados.is_valid(current_state):
		return

	var move := Move.create(
		current_state.duplicate(true),
		carta.dados,
		carta
	)

	history.insert(0, move)
	history_changed.emit(history)
	var novo_estado = carta.dados.apply(current_state)

	current_state = novo_estado
	state_changed.emit(current_state)
	validate_state(current_state)

func validate_state(state: Array) -> bool:
	if current_stage == null:
		print("Stage nulo")
		return false

	var venceu := current_stage.validate(state)

	if venceu:
		stage_completed.emit(current_stage)
		return true

	return false

func next_stage():
	if current_stage_index + 1 >= stages.size():
		return
	load_stage(current_stage_index + 1)


# --- GET IMPORTANTES PARA RESULTADO e CARREGAR FASE
func get_current_cost() -> int:
	var total := 0
	for op in history:
		total += op.cost()
	return total

func get_available_cards() -> Array[Operacao]:
	if current_stage == null:
		return []
	return current_stage.available_cards

func restart_stage():
	if current_stage == null:
		return
	current_state = current_stage.initial_state.duplicate(true)
	history.clear()
	emit_signal("state_changed", current_state)
