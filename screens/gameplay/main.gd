extends Node2D

const LISTAS_SCENE := preload("res://controller/conteudo/listas/Fase1.tscn")

@onready var phase_container: Node2D = $PhaseContainer
@onready var gameplay_hud: GameplayHUD = $ControllerUserInteractions
@onready var tutorial: TutorialManager = $TutorialCarrossel

var current_phase: Node2D

func _ready() -> void:
	gameplay_hud.tutorial_pressed.connect(tutorial.open_tutorial)
	gameplay_hud.pause_pressed.connect(_on_pause_pressed)

	GameManager.stage_loaded.connect(_on_stage_loaded)
	GameManager.stage_completed.connect(_on_stage_completed)
	
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

	GameManager.next_stage()
	
func _on_stage_loaded(stage: Phase): 
	load_phase(LISTAS_SCENE, stage)

func _on_undo_pressed() -> void:
	if current_phase:
		current_phase.undo()

func _on_pause_pressed() -> void:
	get_tree().paused = true
	$PauseMenu.show()
