extends Control

var t : Tween = null
var tempo_animacao : float = 0.2

var segundos : float = -1 :
	set(seg):
		segundos = seg
		mudar_tempo(seg)

signal animacao_finalizada #vai que precisa né...
signal avancar
signal voltar

func _ready() -> void:
	#inicia la embaixo
	$MarginContainer.position.y = get_viewport_rect().size.y
	liberar_inputs(false)
	hide()


func subir():
	show()
	
	if t != null and t.is_running():
		t.kill()
	
	t = create_tween().set_parallel(true)
	t.set_trans(Tween.TRANS_EXPO)
	t.set_ease(Tween.EASE_OUT)
	
	t.tween_property($MarginContainer, "position:y", 0, tempo_animacao)
	t.tween_property($Fundo, 'color:a', 0.4, tempo_animacao)
	
	t.finished.connect(
		func():
		liberar_inputs(true)
		animacao_finalizada.emit()
		)

func descer():
	if t != null and t.is_running():
		t.kill()
	
	t = create_tween().set_parallel(true)
	t.set_trans(Tween.TRANS_EXPO)
	t.set_ease(Tween.EASE_OUT)
	
	t.tween_property($MarginContainer, "position:y", get_viewport_rect().size.y, tempo_animacao)
	t.tween_property($Fundo, 'color:a', 0, tempo_animacao)
	
	t.finished.connect(
		func():
		liberar_inputs(false)
		animacao_finalizada.emit()
		hide()
		)


func _on_voltar_pressed() -> void:
	descer()
	voltar.emit()


func _on_proximo_pressed() -> void:
	descer()
	avancar.emit()
	
func liberar_inputs(liberar : bool = true):
	if liberar:
		mouse_filter = Control.MOUSE_FILTER_STOP
		mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_INHERITED
	else:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_DISABLED

func mudar_tempo(seg : int):
	var texto = ''
	
	var minutos = floor(seg/60)
	seg = seg % 60
	if minutos:
		texto += '{0}min'.format([minutos])
		if seg:
			texto += ' {0}s'.format([seg])
	elif seg:
		texto += '{0} segundos'.format([seg])
		
	$MarginContainer/PanelContainer/Conteudo/MarginContainer/PanelContainer/MarginContainer/InfoFase/Tempo.text = texto
