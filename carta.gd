extends Control

@export_category("Dados")
@export var dados : Operacao
@export var descricao : String = ''

var controlled : bool = false
var origem : Vector2
var rotacao_original : float
var tween : Tween

@onready var textura = $Grupo/Textura
func _ready() -> void:
	origem = global_position
	rotacao_original = rotation


func _process(_delta: float) -> void:
	if controlled:
		global_position = get_global_mouse_position().clamp(Vector2(10,10), Vector2(1100,600))
	

func _on_button_mouse_entered() -> void:
	_crescer()

func _on_button_button_down() -> void:
	controlled = true
	_rotacionar_gostoso()
	desativar_irmas()

func _on_button_button_up() -> void:
	controlled = false
	
	#vai detectar se foi soltada em cima da "mesa"
	var areas = $Area2D.get_overlapping_areas()
	if areas and areas[0].get_node('../').has_method('add_carta'):
		areas[0].get_node('../').add_carta(self)
	
	_voltar_original()
	_diminuir()
	ativar_irmas()
	

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

func _crescer():
	create_tween().tween_method(mudaroffset, textura.get_instance_shader_parameter('tamanho'), 22, 0.15)
	create_tween().tween_property($Grupo, 'scale',Vector2(1.2, 1.2), 0.15)
	z_index = 5

func _diminuir():
	create_tween().tween_method(mudaroffset, textura.get_instance_shader_parameter('tamanho'), 0, 0.15)
	create_tween().tween_property($Grupo, 'scale',Vector2(1, 1), 0.15)
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
	for filho in $Grupo.get_children():
		filho.set_instance_shader_parameter('escala', filho.scale)
		filho.set_instance_shader_parameter('tamanho', off)
