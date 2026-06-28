class_name Operacao
extends Resource

enum Tipo {
	PUSH,
	POP,
	UPDATE,
	INSERT,
	REMOVE,
	REVERSE,
	SORT,
	SLICE,
	FILTER,
	MAP
}

var tipo: Tipo

var posicao: int = -1
var posicao_final: int = -1

var elemento = null
var elemento_final = null

var tamanho_array: int = 0

enum Funcoes {
	NONE,
	FILTRO_PARES,
	FILTRO_IMPARES,
	MAP_DOUBLE,
	MAP_HALF,
}

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

func clone() -> Operacao:
	var nova := Operacao.new()

	nova.tipo = tipo
	nova.posicao = posicao
	nova.posicao_final = posicao_final
	nova.tamanho_array = tamanho_array

	nova.elemento = elemento
	nova.elemento_final = elemento_final

	return nova

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

func apply(state: Array) -> Array:
	var novo_estado := state.duplicate(true)
	match tipo:
		Tipo.PUSH:
			novo_estado.append(elemento)
		Tipo.POP:
			if novo_estado.size() > 0:
				novo_estado.pop_back()
		Tipo.UPDATE:
			if posicao >= 0 and posicao < novo_estado.size():
				novo_estado[posicao] = elemento
		Tipo.INSERT:
			if posicao >= 0 and posicao <= novo_estado.size():
				novo_estado.insert(posicao, elemento)
		Tipo.REMOVE:
			if posicao >= 0 and posicao < novo_estado.size():
				novo_estado.remove_at(posicao)
		Tipo.REVERSE:
			novo_estado.reverse()
		Tipo.SORT:
			novo_estado.sort()
		Tipo.SLICE:
			novo_estado = novo_estado.slice(
				posicao,
				posicao_final
			)
		# TODO: Funcoes de filter e map
		Tipo.FILTER:
			pass
		Tipo.MAP:
			pass

	return novo_estado
