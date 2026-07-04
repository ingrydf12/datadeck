extends Node2D

const LISTAS_SCENE := preload("res://controller/conteudo/listas/Fase1.tscn")

@onready var phase_container: Node2D = $PhaseContainer
@onready var gameplay_hud: GameplayHUD = $ControllerUserInteractions
@onready var tutorial: TutorialManager = $Tutorial/TutorialCarrossel
var first_time := true
@onready var vitoria = $Resultado/TelaVitoria
@onready var pause = $Pausa

var current_phase: Node2D

var tempo_inicio : int = -1

func _ready() -> void:
	gameplay_hud.tutorial_pressed.connect(tutorial.open_tutorial)
	gameplay_hud.pause_pressed.connect(_on_pause_pressed)
	tutorial.tutorial_closed.connect(_on_tutorial_closed)

	GameManager.stage_loaded.connect(_on_stage_loaded)
	GameManager.stage_completed.connect(_on_stage_completed)
	
	vitoria.avancar.connect(_on_avancar_pressed)
	vitoria.voltar.connect(pause._on_menu_pressed)
	
	GameManager.load_stage(0)

func load_phase(scene: PackedScene, phase_data: Phase) -> void:
	if current_phase:
		current_phase.queue_free()

	current_phase = scene.instantiate()
	phase_container.add_child(current_phase)

	if current_phase.has_method("setup"):
		current_phase.setup(phase_data)

	if current_phase.has_method("undo"):
		gameplay_hud.undo_pressed.connect(current_phase.undo)

func _on_stage_completed(stage: Phase):
	print("Fase", stage.stage_id, "concluída!")

	await get_tree().create_timer(1.0).timeout
	
	get_tree().paused = true
	
	vitoria.subir()
	vitoria.mudar_tempo(floor((Time.get_ticks_msec() - tempo_inicio) / 1000))

func _on_stage_loaded(stage: Phase): 
	tempo_inicio = Time.get_ticks_msec() 
	load_phase(LISTAS_SCENE, stage)
	
	if first_time:
		first_time = false

		await get_tree().process_frame
		tutorial.open_tutorial()
		
func _on_tutorial_closed():
	if current_phase and current_phase.has_method("start_card_hint"):
		current_phase.start_card_hint()

#isso aqui é inacessivel
func _on_undo_pressed() -> void:
	if current_phase:
		current_phase.undo()
		#var success = current_phase.undo()
		#if success:
			#gameplay_hud.play_sound(GameplayHUD.Audios.SWIPE, true)
		#else:
			#gameplay_hud.play_sound(GameplayHUD.Audios.ERR)

func _on_pause_pressed() -> void:
		pause.open()

func _on_avancar_pressed() -> void:
	await vitoria.animacao_finalizada
	
	get_tree().paused = false
	
	GameManager.next_stage()
