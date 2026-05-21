extends Node2D


@export_category("Dados")
@export var dados : Operacao
@export var descricao : String = ''
var controlled : bool = false
var origem : Vector2
var rotacao_original : float
var tween : Tween

func _ready() -> void:
	origem = global_position
	rotacao_original = rotation


func _process(_delta: float) -> void:
	if controlled:
		global_position = get_global_mouse_position().clamp(Vector2(10,10), Vector2(1100,600))
	

func _on_button_mouse_entered() -> void:
	create_tween().tween_property($Sprite2D, 'scale',Vector2(4.8,4.8), 0.15)
	create_tween().tween_property($Label, 'scale',Vector2(1.2,1.2), 0.15)
	create_tween().tween_property($Sprite2D, 'offset',Vector2(-2,-2), 0.15)
	z_index = 5

func _on_button_button_down() -> void:
	controlled = true
	if tween and tween.is_running():
		tween.kill()
	
	tween = create_tween()
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, 'rotation', 0, 0.5)
	z_index = 8
	desativar_irmas()

func _on_button_button_up() -> void:
	controlled = false
	var areas = $Area2D.get_overlapping_areas()
	if areas and areas[0].get_node('../').has_method('add_carta'):
		areas[0].get_node('../').add_carta(self)
	
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
	
	create_tween().tween_property($Sprite2D, 'scale',Vector2(4, 4), 0.15)
	create_tween().tween_property($Label, 'scale',Vector2(1, 1), 0.15)
	ativar_irmas()
	

func _on_button_mouse_exited() -> void:
	create_tween().tween_property($Sprite2D, 'scale',Vector2(4, 4), 0.15)
	create_tween().tween_property($Label, 'scale',Vector2(1, 1), 0.15)
	create_tween().tween_property($Sprite2D, 'offset',Vector2.ZERO, 0.15)
	z_index = 0
	
func desativar_irmas():
	for c in get_parent().get_children():
		if c == self: continue
		var b : Button = c.get_child(0)
		b.mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_DISABLED
		
func ativar_irmas():
	for c in get_parent().get_children():
		if c == self: continue
		var b : Button = c.get_child(0)
		b.mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_INHERITED
