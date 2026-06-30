extends CanvasLayer

signal carta_jogada(carta : Carta)

@onready var objetivo_container = $ArrayObjetivo/MarginContainer/VBoxContainer/HBoxContainer
@onready var historico_container = $Historico/PanelContainer/VBoxContainer
@onready var cartas_container = $Control/PanelContainer/Cartas

const CAPA_SCENE = preload("res://models/Capa.tscn")
const CARTA_SCENE = preload("res://screens/gameplay/Interactions/Carta.tscn")

func _ready() -> void:
	GameManager.history_changed.connect(atualizar_historico)

func propagar_carta(carta : Carta):
	carta_jogada.emit(carta)

func carregar_array_objetivo(target_state: Array):
	for child in objetivo_container.get_children():
		child.queue_free()

	await get_tree().process_frame

	for index in target_state:
		var capa: Capa = CAPA_SCENE.instantiate()
		objetivo_container.add_child(capa)
		capa.setup(index)
		
func atualizar_historico(history: Array[Move]):
	for child in historico_container.get_children():
		child.queue_free()

	for move: Move in history:
		var textura := TextureRect.new()

		textura.texture = CardFactory.get_back_texture(move.operation.tipo)
		textura.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		textura.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		textura.custom_minimum_size = Vector2(12, 18)

		historico_container.add_child(textura)
	
func remover_ultima_carta_historico():
	if historico_container.get_child_count() == 0:
		return

	historico_container.get_child(-1).queue_free()
