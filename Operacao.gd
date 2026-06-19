class_name Operacao
extends  Resource

enum Tipo {
	PUSH,
	POP,
	INSERT,
	REMOVE,
	REVERSE,
	SORT,
	UPDATE,
	SLICE,
	FILTER,
	MAP
}

enum Funcoes {
	NONE,
	FILTRO_PARES,
	FILTRO_IMPARES,
	MAP_DOUBLE,
	MAP_HALF,
}

@export var tipo : Tipo = Tipo.PUSH
@export var posicao : int = 0
@export var elemento : int = 0
@export var funcao : Funcoes = Funcoes.NONE

func is_callback() -> bool:
	var normais : Array = [Tipo.PUSH, Tipo.POP, Tipo.INSERT, Tipo.REMOVE, Tipo.REVERSE, Tipo.UPDATE, Tipo.SLICE]
	if tipo in normais:
		return false
	return true

func get_callback():
	match funcao:
		Funcoes.FILTRO_PARES: return func(v): return v%2 != 0
		Funcoes.FILTRO_IMPARES: return func(v): return v%2 == 0
		Funcoes.MAP_DOUBLE: return func(v): return v*2
		Funcoes.MAP_HALF: return func(v): return int(v/2)
		_: return func(v): return v

func get_tipo_name():
	return Tipo.keys()[tipo]
