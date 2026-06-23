class_name Capa
extends Control

@export var index: int = 0

@onready var textura: TextureRect = $TextureRect

func setup(valor: int):
	index = valor
	textura.texture = FilmeFactory.get_texture(valor)
