extends Node2D
var cartas : Array = []
var elementos : Array = []

# Mesa -> Interação com os objetos da fase e adição do verso da carta no histórico
func _ready() -> void:
	pass # Replace with function body.

func add_carta(node : Carta):
	var t = TextureRect.new()
	t.texture = CardFactory.get_back_texture(node.dados.tipo)
	t.custom_minimum_size = Vector2(4, 10)
	t.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	t.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
	t.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$PanelContainer/VBoxContainer.add_child(t)

# desfazer por enquanto ta só visual
func desfazer():
	if $PanelContainer/VBoxContainer.get_children().size() > 0:
		$PanelContainer/VBoxContainer.remove_child($PanelContainer/VBoxContainer.get_children()[-1])

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MouseButton.MOUSE_BUTTON_RIGHT:
		desfazer()
