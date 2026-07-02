class_name Carta
extends Control

@export_category("Dados")
@export var dados : Operacao
@export var descricao : String = 'teste'

var controlled : bool = false
var origem : Vector2 = Vector2(0,0)
var rotacao_original : float = 0
var tween : Tween
var tamanho_shader: float = 0.0

@onready var textura = $Texture

func _ready():
	resetar_na_mao()
	pass
			
func setup(operation: Operacao) -> void:
	dados = operation
	
	$PopupDetalhes.title = Operacao.Tipo.keys()[dados.tipo]
	_preparar()

func _process(_delta: float) -> void:
	if controlled:
		global_position = (get_global_mouse_position() - size/2).clamp(Vector2(10,10), Vector2(1280,720))

# - - - - - - - - - - - FUNCIONALIDADES E EVENTOS

func _on_button_mouse_entered() -> void:
	parar_hint()
	CursorManager.set_cursor(CursorManager.CursorType.PICK)
	_crescer()

func _on_button_button_down() -> void:
	parar_hint()

	if !dados.is_valid(GameManager.current_state):
		return
	#caso ele queira ver os detalhes
	#if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		#var tam = get_viewport_rect().size
		#var meio : Vector2 = get_viewport_transform().affine_inverse() * tam/2
		#if global_position.x <= meio.x:
			#$PopupDetalhes.global_position = meio - tam/4 - $PopupDetalhes.size/2
			#$PopupDetalhes.global_position.y += tam.y/4
		#else:
			#$PopupDetalhes.global_position = meio + tam/4 - $PopupDetalhes.size/2
			#$PopupDetalhes.global_position.y -= tam.y/4
		#$PopupDetalhes.show()
		#$Line2D.points[0] = Vector2(0,0)
		#$Line2D.points[1] = $PopupDetalhes.global_position - global_position + $PopupDetalhes.size/2
		#$Line2D.show()
		#return
	#caso normal de clicar e arrastar
	$Line2D.hide()
	$PopupDetalhes.hide()
	controlled = true
	CursorManager.set_cursor(CursorManager.CursorType.PICKED)
	_crescer()
	_rotacionar_gostoso()
	desativar_irmas()

func _on_button_button_up() -> void:
	controlled = false
	CursorManager.set_cursor(CursorManager.CursorType.NORMAL)
	_voltar_original()
	_diminuir()
	ativar_irmas()

	HudCartas.propagar_carta(self)

func _on_button_mouse_exited() -> void:
	if not controlled:
		CursorManager.set_cursor(CursorManager.CursorType.NORMAL)
	_diminuir()

func desativar_irmas():
	for c in HudCartas.cartas_container.get_cartas():
		if c == self: continue
		c.get_parent().mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_DISABLED

func ativar_irmas():
	for c in HudCartas.cartas_container.get_cartas():
		if c == self: continue
		c.get_parent().mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_INHERITED

func _preparar():
	mudar_textura_carta(Operacao.Tipo.keys()[dados.tipo].to_lower())
	match dados.tipo:
		Operacao.Tipo.PUSH:
			ativar_params(1)
		Operacao.Tipo.POP:
			ativar_params(0)
		Operacao.Tipo.UPDATE:
			ativar_params(2)
		Operacao.Tipo.INSERT:
			ativar_params(2)
		Operacao.Tipo.REMOVE:
			ativar_params(1)
		Operacao.Tipo.SLICE:
			ativar_params(2)
		Operacao.Tipo.REVERSE:
			ativar_params(0)
	atualizar_parametros(dados)

# - - - - - - - - - - - - - ANIMAÇÕES E VISUAL

var estado_atual:Array

var hint_tween: Tween
var mostrando_hint := false

func iniciar_hint():
	if mostrando_hint:
		return

	mostrando_hint = true

	while mostrando_hint:
		hint_tween = create_tween()

		hint_tween.tween_property(
			$Texture,
			"escala",
			Vector2(4.3, 4.3),
			0.25
		)

		hint_tween.tween_property(
			$Texture,
			"escala",
			Vector2(4.0, 4.0),
			0.25
		)

		await hint_tween.finished
		await get_tree().create_timer(1.0).timeout

func parar_hint():
	mostrando_hint = false

	if hint_tween:
		hint_tween.kill()

	$Texture.scale = Vector2(3, 3)

# gambiarra pra atualizar os parametros das cartas depois que o array usuario muda
func atualizar_contexto(array: Array):
	if dados == null:
		print("CARTA SEM DADOS:", self)
		return

	estado_atual = array
	atualizar_parametros(dados, estado_atual)

func ativar_params(quantos):
	$Texture/Control/Parametros/P1.hide()
	$Texture/Control/Parametros/P2.hide()
	if quantos > 0:
		$Texture/Control/Parametros/P1.show()
	if quantos > 1:
		$Texture/Control/Parametros/P2.show()

func mudar_textura_carta(tipo : String):
	var ordem = ['reverse', 'sort', 'slice','pop','filter','map','update', 'push', 'remove']
	var indx = ordem.find(tipo)
	$Texture.texture.region = Rect2(37*indx, 0, 37, 52)
	$Sombra.texture.region = Rect2(37*indx, 0, 37, 52)

func atualizar_parametros(data: Operacao, estado: Array = []):
	match data.tipo:
		Operacao.Tipo.PUSH:
			if data.elemento == null:
				return
			$Texture/Control/Parametros/P1/Base/Label.text = str(data.elemento)
			atualizar_numero(
				$Texture/Control/Parametros/P1/Capa,
				data.elemento
			)
		Operacao.Tipo.POP:
			# POP()
			$Texture/Control/Parametros/P1/Base/Label.text = ""
		Operacao.Tipo.UPDATE:
			$Texture/Control/Parametros/P1/Base/Label.text = str(data.posicao)
			if estado.size() > data.posicao:
				atualizar_numero(
					$Texture/Control/Parametros/P1/Capa,
					estado[data.posicao]
				)
			$Texture/Control/Parametros/P2/Base/Label.text = str(data.elemento)
			atualizar_numero(
				$Texture/Control/Parametros/P2/Capa,
				data.elemento
			)
		Operacao.Tipo.INSERT:
			# INSERT(posicao, valor)
			$Texture/Control/Parametros/P1/Base/Label.text = str(data.posicao)
			$Texture/Control/Parametros/P2/Base/Label.text = str(data.elemento)
			atualizar_numero(
				$Texture/Control/Parametros/P2/Capa,
				data.elemento
			)
		Operacao.Tipo.REMOVE:
			# REMOVE(posicao)
			$Texture/Control/Parametros/P1/Base/Label.text = str(data.posicao)
		Operacao.Tipo.REVERSE:
			# REVERSE()
			pass
		Operacao.Tipo.SORT:
			# SORT()
			pass
		Operacao.Tipo.SLICE:
			$Texture/Control/Parametros/P1/Base/Label.text = str(data.posicao)
			$Texture/Control/Parametros/P2/Base/Label.text = str(data.posicao_final)
		Operacao.Tipo.FILTER:
			pass
		Operacao.Tipo.MAP:
			pass
			
func atualizar_numero(capa: TextureRect, valor:int):
	capa.texture.region = Rect2(
		valor * 12,
		0,
		12,
		18
	)

func resetar_na_mao():
	origem = position
	rotation = 0
	z_index = 0

func _crescer():
	if tween and tween.is_running():
		tween.kill()

	tween = create_tween()
	tween.set_parallel()

	tween.tween_method(
		func(valor):
			tamanho_shader = valor
			mudaroffset(valor),
		0.0,
		22.0,
		0.15
	)

	tween.tween_property(
		$Texture,
		"escala",
		Vector2(4.8,4.8),
		0.15
	)

	z_index = 5

func _diminuir():
	create_tween().tween_method(mudaroffset, textura.get_instance_shader_parameter('tamanho'), 0, 0.15)
	create_tween().tween_property($Texture, 'escala',Vector2(4, 3), 0.15)
	z_index = 0

func _voltar_original():
	if origem == null or rotacao_original == null:
		return

	if tween and tween.is_running():
		tween.kill()

	tween = create_tween()
	tween.set_parallel()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, 'position', origem, 0.15)
	tween.tween_property(self, 'rotation', rotacao_original, 0.15)

func _rotacionar_gostoso():
	if tween and tween.is_running():
		tween.kill()

	tween = create_tween()
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, 'rotation', 0, 0.5)
	z_index = 8

func mudaroffset(off : float):
	$Texture.set_instance_shader_parameter('escala', $Texture.scale)
	$Texture.set_instance_shader_parameter('tamanho', off)

	#TODO: refazer tudo so que melhor
	if $Texture/Control/Parametros/P1.visible:
		$Texture/Control/Parametros/P1/Capa.set_instance_shader_parameter('escala', $Texture.scale/4)
		$Texture/Control/Parametros/P1/Capa.set_instance_shader_parameter('tamanho', off)
		$Texture/Control/Parametros/P1/Base.set_instance_shader_parameter('escala', $Texture.scale/4)
		$Texture/Control/Parametros/P1/Base.set_instance_shader_parameter('tamanho', off)
		$Texture/Control/Parametros/P1/Base/Label.set_instance_shader_parameter('escala', $Texture.scale/4)
		$Texture/Control/Parametros/P1/Base/Label.set_instance_shader_parameter('tamanho', off)

	if $Texture/Control/Parametros/P2.visible:
		$Texture/Control/Parametros/P2/Capa.set_instance_shader_parameter('escala', $Texture.scale/4)
		$Texture/Control/Parametros/P2/Capa.set_instance_shader_parameter('tamanho', off)
		$Texture/Control/Parametros/P2/Base.set_instance_shader_parameter('escala', $Texture.scale/4)
		$Texture/Control/Parametros/P2/Base.set_instance_shader_parameter('tamanho', off)
		$Texture/Control/Parametros/P2/Base/Label.set_instance_shader_parameter('escala', $Texture.scale/4)
		$Texture/Control/Parametros/P2/Base/Label.set_instance_shader_parameter('tamanho', off)
