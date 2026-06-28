class_name Move
extends Resource

var previous: Array
var operation: Operacao
var card: Carta

static func create(previous_state: Array, operation: Operacao, card: Carta) -> Move:
	var move := Move.new()
	move.previous = previous_state
	move.operation = operation
	move.card = card
	return move
