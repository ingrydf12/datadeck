class_name Capa
extends TextureRect

@export var index := 0

const LARGURA_SPRITE := 12
const ESPACAMENTO := 0


func setup(valor:int):
	index = valor

	var atlas := texture.duplicate()

	atlas.region = Rect2(
		(LARGURA_SPRITE + ESPACAMENTO) * valor,
		0,
		LARGURA_SPRITE,
		18
	)

	texture = atlas
