extends Node2D
const FASE_SCENE = preload("res://Fase1.tscn")

func _ready():
	var phase = Phase.build_all_stages()[0]
	var fase_node = FASE_SCENE.instantiate()
	
	add_child(fase_node)
	fase_node.setup(phase)
