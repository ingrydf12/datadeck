class_name Phase
extends Resource

var stage_id: int

var concept: String
var description: String

var initial_state: Array # array usuário
var target_state: Array # array objetivo

var available_cards: Array[Operacao]

func validate(state: Array) -> bool:
	return state == target_state

static func create(
	id:int,
	stage_concept:String,
	description:String,
	initial_state:Array,
	target_state:Array,
	cards:Array[Operacao]
) -> Phase:

	for op in cards:
		op.tamanho_array = initial_state.size()

	var s := Phase.new()
	s.stage_id = id
	s.concept = stage_concept
	s.description = description
	s.initial_state = initial_state
	s.target_state = target_state
	s.available_cards = cards

	return s

static func _create_operation(
	tipo: Operacao.Tipo,
	elemento := 0,
	elemento_final := 0,
	posicao := 0,
	posicao_final := 0
) -> Operacao:
	var op := Operacao.new()

	op.tipo = tipo
	op.elemento = elemento
	op.elemento_final = elemento_final
	op.posicao = posicao
	op.posicao_final = posicao_final

	return op

static func build_all_stages() -> Array[Phase]:
	return [
		create(
			1,
			"PUSH e POP",
			"Aprenda a substituir o último elemento.",
			[1, 2, 5],
			[1, 2, 3],
			[
				_create_operation(Operacao.Tipo.PUSH, 3),
				_create_operation(Operacao.Tipo.POP)
			]
		),

		create(
			2,
			"REVERSE",
			"Inverta a lista.",
			[4, 3, 2, 1],
			[1, 2, 3, 4],
			[
				_create_operation(Operacao.Tipo.PUSH, 5),
				_create_operation(Operacao.Tipo.POP),
				_create_operation(Operacao.Tipo.REVERSE)
			]
		),

		create(
			3,
			"TROCA",
			"Uma única carta nem sempre resolve o problema. Combine operações para chegar ao objetivo.",
			[2, 1, 3],
			[1, 2, 3],
			[
				_create_operation(Operacao.Tipo.PUSH, 4),
				_create_operation(Operacao.Tipo.POP),
				_create_operation(Operacao.Tipo.INSERT, 2),
				_create_operation(Operacao.Tipo.REMOVE, 1),
				_create_operation(Operacao.Tipo.UPDATE, 1, 5)
			]
		)
	]
