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
@export var posicao_final : int = 0
@export var elemento_final : int = 0
@export var tamanho_array: int = 0
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
		
func is_valid(state:Array) -> bool:
	match tipo:
		Tipo.PUSH:
			return true
		Tipo.POP:
			return state.size() > 0
		Tipo.UPDATE:
			return posicao >= 0 and posicao < state.size()
		Tipo.INSERT:
			return posicao >= 0 and posicao <= state.size()
		Tipo.REMOVE:
			return posicao >= 0 and posicao < state.size()
		Tipo.REVERSE:
			return state.size() > 1
		Tipo.SORT:
			return state.size() > 1
	return false

func get_tipo_name():
	return Tipo.keys()[tipo]
	
func apply(state: Array) -> Array:
	var novo_estado := state.duplicate(true)

	match tipo:
		Tipo.PUSH:
			novo_estado.append(elemento)
		Tipo.POP:
			novo_estado.pop_back()
		Tipo.UPDATE:
			novo_estado[posicao] = elemento
		Tipo.INSERT:
			novo_estado.insert(posicao, elemento)
		Tipo.REMOVE:
			novo_estado.remove_at(posicao)
		Tipo.REVERSE:
			novo_estado.reverse()
		Tipo.SORT:
			novo_estado.sort()
		Tipo.SLICE:
			novo_estado = novo_estado.slice(posicao, posicao_final)
		Tipo.FILTER:
			pass # implementar depois
		Tipo.MAP:
			pass # implementar depois
	return novo_estado
