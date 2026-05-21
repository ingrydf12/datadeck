extends Node2D

var cartas : Array = []
var elementos : Array = []

func _ready() -> void:
	pass # Replace with function body.

func add_carta(node : Node2D):
	var t = TextureRect.new()
	t.texture = node.get_node('./Sprite2D').texture
	t.custom_minimum_size = Vector2(96, 128)
	t.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
	t.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$Container.add_child(t)

func desfazer():
	if $Container.get_children().size() > 0:
		$Container.remove_child($Container.get_children()[-1])

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MouseButton.MOUSE_BUTTON_RIGHT:
		desfazer()
