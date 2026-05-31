extends Node2D

var follow_mouse = true;

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	
	if follow_mouse:
		$Camera2D.global_position = get_global_mouse_position()
