@tool

class_name Filme
extends Control

@export var indice : int = 0:
	set(v):
		get_node("Control/Base/Label").text = str(v)
		indice = v

@export_range(0,6,1) var valor : int = 0:
	set(v):
		$Control/Capa.texture.region = Rect2((33+1)*v, 0, 33, 48)
		valor = v

func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		$Control/Base/Label.text = str(indice)
		$Control/Capa.texture.region = Rect2((33+1)*valor, 0, 33, 48)
	pass
