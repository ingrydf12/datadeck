@tool
extends Path2D

@onready var line : Line2D = $Line2D
func _ready() -> void:
	#print(get_filler_points(2))
	if not Engine.is_editor_hint():
		line.hide()
	pass

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		line.points = curve.get_baked_points()

func get_filler_points(n_elements: int) -> Array[Transform2D]:
	var tam = curve.get_baked_length()
	var espaco = tam/(n_elements+1)
	var lista : Array[Transform2D] = []
	
	for i in range(n_elements):
		lista.append(curve.sample_baked_with_rotation((i+1)*espaco))
		
	return lista
