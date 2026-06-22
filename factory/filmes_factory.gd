class_name FilmeFactory
extends Node

# linkar aqui as capas de filme e index relacionado
const FILME_TEXTURES = {
	1: preload("res://assets/filmes/filme_01.png"),
	2: preload("res://assets/filmes/filme_02.png"),
	3: preload("res://assets/filmes/filme_03.png"),
	4: preload("res://assets/filmes/filme_04.png"),
	5: preload("res://assets/filmes/filme_05.png"),
	6: preload("res://assets/filmes/filme_06.png"),
}

static func get_texture(numero: int) -> Texture2D:
	return FILME_TEXTURES.get(numero)
