extends Node

signal state_changed(state: Array)
signal stage_loaded(stage: Phase)
signal stage_completed(stage: Phase)

var stages: Array[Phase] = []
var current_stage_index: int = 0
var current_stage: Phase

var current_state: Array = []
var history: Array[Move] = []

func initialize():
	stages = Phase.build_all_stages()

	if stages.size() > 0:
		load_stage(0)

func load_stage(index: int):
	if index < 0 or index >= stages.size():
		return

	current_stage_index = index
	current_stage = stages[index]

	current_state = current_stage.initial_state.duplicate(true)

	history.clear()

	stage_loaded.emit(current_stage)
	state_changed.emit(current_state)

func apply_operation(operation: Operacao):
	if operation == null:
		return

	if !operation.is_valid(current_state):
		print("Operação inválida.")
		return

	history.append(
		Move.create(current_state, operation)
	)

	current_state = operation.apply(current_state)
	state_changed.emit(current_state)

	if check_victory():
		await _handle_victory()

func check_victory() -> bool:
	return current_stage.validate(current_state)

func _handle_victory():
	emit_signal("stage_completed", current_stage)
	await get_tree().create_timer(1.0).timeout
	next_stage()

func next_stage():
	if current_stage_index + 1 >= stages.size():
		print("Fim do jogo.")
		return
	load_stage(current_stage_index + 1)
	
func undo():
	if history.is_empty():
		return

	var move: Move = history.pop_back()

	current_state = move.previous_state.duplicate(true)
	state_changed.emit(current_state)

func get_current_cost() -> int:
	var total := 0
	for op in history:
		total += op.cost()
	return total

func restart_stage():
	if current_stage == null:
		return
	current_state = current_stage.initial_state.duplicate(true)
	history.clear()
	emit_signal("state_changed", current_state)

func get_available_cards() -> Array[Operacao]:
	if current_stage == null:
		return []
	return current_stage.available_cards
