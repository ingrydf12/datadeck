class_name GameManager
extends Node

var stages: Array[Stage] = []

var current_stage_index: int = 0
var current_stage: Stage

# Estado atual do jogador
var current_state: Array = []

func _ready():
	stages = Stage.build_all_stages()

	if stages.size() > 0:
		load_stage(0)

# debugs
func load_stage(index: int):
	if index < 0 or index >= stages.size():
		return

	current_stage_index = index
	current_stage = stages[index]

	current_state = current_stage.initial_state.duplicate()

	print("==========")
	print("Fase:", current_stage.stage_id)
	print(current_stage.concept)
	print(current_stage.description)
	print("Estado inicial:", current_state)
	print("Objetivo:", current_stage.target_state)


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
	return current_state == current_stage.target_state

func next_stage():
	if current_stage_index + 1 >= stages.size():
		print("Fim do jogo.")
		return

	load_stage(current_stage_index + 1)

func restart_stage():
	if current_stage == null:
		return
	current_state = current_stage.initial_state.duplicate()

	print("Fase reiniciada.")
	print(current_state)

func get_available_cards() -> Array[Operacao.Tipo]:
	if current_stage == null:
		return []

	return current_stage.available_cards
