class_name GameManager
extends Node

var stages: Array[Phase] = []

var current_stage_index: int = 0
var current_stage: Phase

# Estado atual do jogador
var current_state: Array = []

var operation_history:Array[Operacao] = []

func _ready():
	stages = Phase.build_all_stages()

	if stages.size() > 0:
		load_stage(0)

# debugs
func load_stage(index: int):
	if index < 0 or index >= stages.size():
		return

	current_stage_index = index
	current_stage = stages[index]

	current_state = current_stage.initial_state.duplicate()

	print(current_stage.concept)
	print(current_stage.description)


func apply_operation(operation: Operacao):
	if operation == null:
		return

	if !operation.is_valid(current_state):
		print("Operação inválida.")
		return

	current_state = operation.apply(current_state)

	print("Estado atual:", current_state)

	if check_victory():
		print("Fase concluída!")

func check_victory() -> bool:
	return current_stage.validate(current_state)

func next_stage():
	if current_stage_index + 1 >= stages.size():
		return

	load_stage(current_stage_index + 1)

func get_current_cost() -> int:
	var total := 0

	for op in operation_history:
		total += op.cost()

	return total

func restart_stage():
	if current_stage == null:
		return

	current_state = current_stage.initial_state.duplicate()
	operation_history.clear()

	emit_signal("state_changed", current_state)

func get_available_cards() -> Array[Operacao.Tipo]:
	if current_stage == null:
		return []

	return current_stage.available_cards
