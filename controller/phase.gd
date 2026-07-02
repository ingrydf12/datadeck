class_name Phase
extends Resource

var stage_id: int
var concept: String
var description: String

var initial_state: Array
var target_state: Array

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

	var cloned_cards:Array[Operacao] = []

	for op in cards:
		var clone := op.clone()
		clone.tamanho_array = initial_state.size()

		print(
			"CLONE:",
			clone.tipo,
			clone.elemento
		)

		cloned_cards.append(clone)

	var s := Phase.new()
	s.stage_id = id
	s.concept = stage_concept
	s.description = description
	s.initial_state = initial_state
	s.target_state = target_state
	s.available_cards = cloned_cards

	return s

static func _create_operation(
	tipo: Operacao.Tipo,
	posicao := -1,
	valor = null,
	posicao_final := -1
) -> Operacao:
	var op := Operacao.new()

	op.tipo = tipo
	op.posicao = posicao
	op.elemento = valor
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
				_create_operation(Operacao.Tipo.PUSH, -1, 3),
				_create_operation(Operacao.Tipo.POP),
				_create_operation(Operacao.Tipo.REVERSE)
			]
		),

		create(
			2,
			"REVERSE",
			"Inverta a lista.",
			[4, 3, 2, 1],
			[1, 2, 3, 4],
			[
				_create_operation(Operacao.Tipo.REVERSE),
				_create_operation(Operacao.Tipo.PUSH, -1, 4),
				_create_operation(Operacao.Tipo.POP),
				_create_operation(Operacao.Tipo.UPDATE, 0, 2)
			]
		),

		create(
			3,
			"UPDATE",
			"Corrija os valores.",
			[2, 1, 3],
			[1, 2, 3],
			[
				_create_operation(Operacao.Tipo.UPDATE, 0, 1),
				_create_operation(Operacao.Tipo.UPDATE, 1, 2),
				_create_operation(Operacao.Tipo.REVERSE),
				_create_operation(Operacao.Tipo.PUSH, -1, 4)
			]
		),

		create(
			4,
			"PUSH",
			"Adicione um elemento.",
			[1, 2],
			[1, 2, 3],
			[
				_create_operation(Operacao.Tipo.PUSH, -1, 3),
				_create_operation(Operacao.Tipo.PUSH, -1, 2),
				_create_operation(Operacao.Tipo.POP),
				_create_operation(Operacao.Tipo.REVERSE)
			]
		),

		create(
			5,
			"POP",
			"Remova o último elemento.",
			[1, 2, 3],
			[1, 2],
			[
				_create_operation(Operacao.Tipo.POP),
				_create_operation(Operacao.Tipo.PUSH, -1, 2),
				_create_operation(Operacao.Tipo.UPDATE, 1, 1),
				_create_operation(Operacao.Tipo.REVERSE)
			]
		),

		create(
			6,
			"UPDATE",
			"Altere apenas o primeiro valor.",
			[5, 2, 3],
			[1, 2, 3],
			[
				_create_operation(Operacao.Tipo.UPDATE, 0, 1),
				_create_operation(Operacao.Tipo.UPDATE, 2, 2),
				_create_operation(Operacao.Tipo.REVERSE),
				_create_operation(Operacao.Tipo.PUSH, -1, 4),
				_create_operation(Operacao.Tipo.POP)
			]
		),

		create(
			7,
			"REVERSE",
			"Inverta a sequência.",
			[5, 4, 3, 2, 1],
			[1, 2, 3, 4, 5],
			[
				_create_operation(Operacao.Tipo.REVERSE),
				_create_operation(Operacao.Tipo.POP),
				_create_operation(Operacao.Tipo.PUSH, -1, 6),
				_create_operation(Operacao.Tipo.UPDATE, 0, 4),
				_create_operation(Operacao.Tipo.UPDATE, 4, 2)
			]
		),

		create(
			8,
			"PUSH + UPDATE",
			"Complete a sequência.",
			[1, 2],
			[1, 2, 4],
			[
				_create_operation(Operacao.Tipo.PUSH, -1, 3),
				_create_operation(Operacao.Tipo.UPDATE, 2, 4),
				_create_operation(Operacao.Tipo.REVERSE),
				_create_operation(Operacao.Tipo.POP),
				_create_operation(Operacao.Tipo.UPDATE, 0, 2)
			]
		),

		create(
			9,
			"POP + PUSH",
			"Troque o último elemento.",
			[1, 2, 6],
			[1, 2, 5],
			[
				_create_operation(Operacao.Tipo.POP),
				_create_operation(Operacao.Tipo.PUSH, -1, 5),
				_create_operation(Operacao.Tipo.REVERSE),
				_create_operation(Operacao.Tipo.UPDATE, 2, 4),
				_create_operation(Operacao.Tipo.PUSH, -1, 4),
				_create_operation(Operacao.Tipo.UPDATE, 1, 3)
			]
		),

		create(
			10,
			"REVERSE + UPDATE",
			"Inverta e ajuste.",
			[4, 3, 2, 6],
			[1, 2, 3, 4],
			[
				_create_operation(Operacao.Tipo.REVERSE),
				_create_operation(Operacao.Tipo.UPDATE, 0, 1),
				_create_operation(Operacao.Tipo.POP),
				_create_operation(Operacao.Tipo.PUSH, -1, 5),
				_create_operation(Operacao.Tipo.UPDATE, 3, 3),
				_create_operation(Operacao.Tipo.UPDATE, 1, 1)
			]
		),

		create(
			11,
			"Sequência",
			"Combine várias operações.",
			[3, 2],
			[1, 2, 3],
			[
				_create_operation(Operacao.Tipo.REVERSE),
				_create_operation(Operacao.Tipo.UPDATE, 0, 1),
				_create_operation(Operacao.Tipo.PUSH, -1, 3),
				_create_operation(Operacao.Tipo.POP),
				_create_operation(Operacao.Tipo.UPDATE, 1, 3),
				_create_operation(Operacao.Tipo.PUSH, -1, 2)
			]
		),

		create(
			12,
			"Desafio Final",
			"Utilize apenas as cartas corretas.",
			[6, 2, 1],
			[1, 2, 3],
			[
				_create_operation(Operacao.Tipo.REVERSE),
				_create_operation(Operacao.Tipo.POP),
				_create_operation(Operacao.Tipo.PUSH, -1, 3),
				_create_operation(Operacao.Tipo.PUSH, -1, 2),
				_create_operation(Operacao.Tipo.UPDATE, 0, 2),
				_create_operation(Operacao.Tipo.UPDATE, 2, 1),
				_create_operation(Operacao.Tipo.REVERSE)
			]
		)
	]
