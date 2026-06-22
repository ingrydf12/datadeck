class_name CardFactory
extends Node

# Factory pra linkar os sprites de cartas + versos
const CARD_TEXTURES = {
	Operacao.Tipo.PUSH: preload("res://assets/cards/push.png"),
	Operacao.Tipo.POP: preload("res://assets/cards/pop.png"),
	Operacao.Tipo.INSERT: preload("res://assets/cards/insert.png"),
	Operacao.Tipo.REMOVE: preload("res://assets/cards/remove.png"),
	Operacao.Tipo.UPDATE: preload("res://assets/cards/update.png"),
	Operacao.Tipo.REVERSE: preload("res://assets/cards/reverse.png"),
	Operacao.Tipo.SORT: preload("res://assets/cards/sort.png"),
	Operacao.Tipo.SLICE: preload("res://assets/cards/slice.png"),
	Operacao.Tipo.FILTER: preload("res://assets/cards/filter.png"),
	Operacao.Tipo.MAP: preload("res://assets/cards/map.png"),
}

const CARD_BACK_TEXTURES = {
	Operacao.Tipo.PUSH: preload("res://assets/cards/back/push.png"),
	Operacao.Tipo.POP: preload("res://assets/cards/back/pop.png"),
	Operacao.Tipo.INSERT: preload("res://assets/cards/back/insert.png"),
	Operacao.Tipo.REMOVE: preload("res://assets/cards/back/remove.png"),
	Operacao.Tipo.UPDATE: preload("res://assets/cards/back/update.png"),
	Operacao.Tipo.REVERSE: preload("res://assets/cards/back/reverse.png"),
	Operacao.Tipo.SORT: preload("res://assets/cards/back/sort.png"),
	Operacao.Tipo.SLICE: preload("res://assets/cards/back/slice.png"),
	Operacao.Tipo.FILTER: preload("res://assets/cards/back/filter.png"),
	Operacao.Tipo.MAP: preload("res://assets/cards/back/map.png"),
}

static func get_texture(card_type: Operacao.Tipo) -> Texture2D:
	return CARD_TEXTURES.get(card_type)

static func get_back_texture(card_type: Operacao.Tipo) -> Texture2D:
	return CARD_BACK_TEXTURES.get(card_type)
