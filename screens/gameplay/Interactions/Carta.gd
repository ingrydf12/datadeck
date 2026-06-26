@tool

class_name Carta
extends Control

@export_category("Dados")
@export var dados : Operacao
@export var descricao : String = 'teste'

var controlled : bool = false
var origem : Vector2
var rotacao_original : float
var tween : Tween

@onready var textura = $Texture

func _ready() -> void:
	origem = global_position
	rotacao_original = rotation
	#$PopupDetalhes.title = Operacao.Tipo.keys()[dados.tipo] #.to_pascal_case() caso queira Capitalizar A Palavra
	#$PopupDetalhes.desc = descricao
	#mudar_textura_carta(Operacao.Tipo.keys()[dados.tipo].to_lower())
	_preparar()

func setup(operation: Operacao):
	dados = operation
	$PopupDetalhes.title = Operacao.Tipo.keys()[dados.tipo]

	mudar_textura_carta(
		Operacao.Tipo.keys()[dados.tipo].to_lower()
	)

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		$PopupDetalhes.title = Operacao.Tipo.keys()[dados.tipo] #.to_pascal_case() caso queira Capitalizar A Palavra
		$PopupDetalhes.desc = descricao
		mudar_textura_carta(Operacao.Tipo.keys()[dados.tipo].to_lower())
		return
	
	if controlled:
		global_position = get_global_mouse_position().clamp(Vector2(10,10), Vector2(1100,600))



# - - - - - - - - - - - FUNCIONALIDADES E EVENTOS

func _on_button_mouse_entered() -> void:
	_crescer()

func _on_button_button_down() -> void:
	#caso ele queira ver os detalhes
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		var tam = get_viewport_rect().size
		var meio : Vector2 = get_viewport_transform().affine_inverse() * tam/2
		print(meio-tam/4)
		if global_position.x <= meio.x:
			$PopupDetalhes.global_position = meio - tam/4 - $PopupDetalhes.size/2
			$PopupDetalhes.global_position.y += tam.y/4
		else:
			$PopupDetalhes.global_position = meio + tam/4 - $PopupDetalhes.size/2
			$PopupDetalhes.global_position.y -= tam.y/4
		$PopupDetalhes.show()
		$Line2D.points[0] = Vector2(0,0)
		$Line2D.points[1] = $PopupDetalhes.global_position - global_position + $PopupDetalhes.size/2
		$Line2D.show()
		return
	
	#caso normal de clicar e arrastar
	$Line2D.hide()
	$PopupDetalhes.hide()
	controlled = true
	_rotacionar_gostoso()
	desativar_irmas()
	
func _on_button_button_up() -> void:
	
	controlled = false
	
	##vai detectar se foi soltada em cima da "mesa"
	#var areas = $Area2D.get_overlapping_areas()
	#if areas and areas[0].get_node('../').has_method('add_carta'):
		#areas[0].get_node('../').add_carta(self)
	
	_voltar_original()
	_diminuir()
	ativar_irmas()
	
	HudCartas.propagar_carta(self)

	
func _on_button_mouse_exited() -> void:
	_diminuir()
	
func desativar_irmas():
	for c in get_parent().get_children():
		if c == self or c is not Control: continue
		var b : Button = c.get_child(-1)
		b.mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_DISABLED
		
func ativar_irmas():
	for c in get_parent().get_children():
		if c == self or c is not Control: continue
		var b : Button = c.get_child(-1)
		b.mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_INHERITED

func _preparar():
	mudar_textura_carta(Operacao.Tipo.keys()[dados.tipo].to_lower())
	match dados.tipo:
		Operacao.Tipo.PUSH:
			ativar_params(1)
		Operacao.Tipo.POP:
			ativar_params(0)
	atualizar_parametros(dados)

# - - - - - - - - - - - - - ANIMAÇÕES E VISUAL

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
	$Sombra.region_rect = Rect2(37*indx, 0, 37, 52)

func atualizar_parametros(data : Operacao):
	$Texture/Control/Parametros/P1/Base/Label.text = str(data.posicao)
	$Texture/Control/Parametros/P2/Base/Label.text = str(data.posicao_final)
	$Texture/Control/Parametros/P1/Capa.texture.region = Rect2((12+1)*data.elemento,0, 12,18)
	$Texture/Control/Parametros/P2/Capa.texture.region = Rect2((12+1)*data.elemento_final,0, 12,18)

func _crescer():
	create_tween().tween_method(mudaroffset, textura.get_instance_shader_parameter('tamanho'), 22, 0.15)
	create_tween().tween_property($Texture, 'scale',Vector2(4.8, 4.8), 0.15)
	z_index = 5

func _diminuir():
	create_tween().tween_method(mudaroffset, textura.get_instance_shader_parameter('tamanho'), 0, 0.15)
	create_tween().tween_property($Texture, 'scale',Vector2(4, 4), 0.15)
	z_index = 0

func _voltar_original():
	if not origem or not rotacao_original:
		return
	
	if tween and tween.is_running():
		tween.kill()
		
	tween = create_tween()
	tween.set_parallel()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, 'global_position', origem, 0.15)
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
		
