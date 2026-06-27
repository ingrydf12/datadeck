class_name Move
extends Resource

var previous: Array
var operation: Operacao

static func create(previous_state: Array, op: Operacao) -> Move:
	var move := Move.new()

	move.previous = previous_state.duplicate(true)
	move.operation = op

	return move
