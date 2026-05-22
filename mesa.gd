extends Node2D

var cartas : Array = []
var elementos : Array = []

func _ready() -> void:
	pass # Replace with function body.

func add_carta(node : Control):
	var t = TextureRect.new()
	t.texture = node.get_node('./Textura').texture
	t.custom_minimum_size = Vector2(4, 10)
	t.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	t.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
	t.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$PanelContainer/VBoxContainer.add_child(t)

func desfazer():
	if $PanelContainer/VBoxContainer.get_children().size() > 0:
		$PanelContainer/VBoxContainer.remove_child($PanelContainer/VBoxContainer.get_children()[-1])

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MouseButton.MOUSE_BUTTON_RIGHT:
		desfazer()
