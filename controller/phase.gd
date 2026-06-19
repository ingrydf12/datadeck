class_name Stage
extends Resource

var stage_id: int

var concept: String
var description: String

var array_usuario: Array
var array_objetivo: Array

var available_cards: Array[Operacao.Tipo]

func validate(state: Array) -> bool:
	return state == array_objetivo

static func create(
	id:int,
	stage_concept:String,
	description:String,
	initial_state:Array,
	target_state:Array,
	cards:Array
) -> Stage:

	var s := Stage.new()

	s.stage_id = id
	s.concept = stage_concept
	s.description = description
	s.initial_state = initial_state
	s.target_state = target_state
	s.available_cards = cards

	return s

# fases disponíveis (MVP)
static func build_all_stages() -> Array[Stage]:
	return [
		create(
			1,
			"PUSH e POP",
			"Aprenda a substituir o último elemento.",
			[1, 2, 5],
			[1, 2, 3],
			[
				Operacao.Tipo.PUSH,
				Operacao.Tipo.POP
			]
		),
		create(
			2,
			"REVERSE",
			"Inverta a lista.",
			[4, 3, 2, 1],
			[1, 2, 3, 4],
			[
				Operacao.Tipo.PUSH,
				Operacao.Tipo.POP,
				Operacao.Tipo.REVERSE
			]
		),
		create(
			3,
			"TROCA",
			"Uma única carta nem sempre resolve o problema. Combine operações para chegar ao objetivo.",
			[2, 1, 3],
			[1, 2, 3],
			[
				Operacao.Tipo.PUSH,
				Operacao.Tipo.POP,
				Operacao.Tipo.INSERT,
				Operacao.Tipo.REMOVE,
				Operacao.Tipo.UPDATE
			]
		),
		create(
			4,
			"REVERSE",
			"Encontre uma solução eficiente.",
			[4, 3, 2, 1, 5],
			[1, 2, 3, 4],
			[
				Operacao.Tipo.PUSH,
				Operacao.Tipo.POP,
				Operacao.Tipo.INSERT,
				Operacao.Tipo.REMOVE,
				Operacao.Tipo.UPDATE,
				Operacao.Tipo.REVERSE
			]
		),
		create(
			5,
			"SORT e REVERSE",
			"Existem várias soluções possíveis. Qual é a melhor?",
			[5, 4, 3, 2, 1, 6],
			[1, 2, 3, 4, 5],
			[
				Operacao.Tipo.PUSH,
				Operacao.Tipo.POP,
				Operacao.Tipo.INSERT,
				Operacao.Tipo.REMOVE,
				Operacao.Tipo.UPDATE,
				Operacao.Tipo.REVERSE,
				Operacao.Tipo.SORT
			]
		),
		create(
			6,
			"FILTER e SLICE",
			"Utilize operações de alto nível para otimizar a solução.",
			[1, 2, 4, 5, 6],
			[2, 3, 4, 5],
			[
				Operacao.Tipo.PUSH,
				Operacao.Tipo.POP,
				Operacao.Tipo.INSERT,
				Operacao.Tipo.REMOVE,
				Operacao.Tipo.UPDATE,
				Operacao.Tipo.REVERSE,
				Operacao.Tipo.SORT,
				Operacao.Tipo.SLICE,
				Operacao.Tipo.FILTER,
				Operacao.Tipo.MAP
			]
		)
	]
