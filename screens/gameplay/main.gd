extends Node2D

const LISTAS_SCENE := preload("res://Fase1.tscn")

@onready var phase_container: Node2D = $PhaseContainer
@onready var gameplay_hud: GameplayHUD = $ControllerUserInteractions
@onready var tutorial: TutorialManager = $TutorialCarrossel

var current_phase: Node2D

func _ready() -> void:
	gameplay_hud.tutorial_pressed.connect(tutorial.open_tutorial)
	gameplay_hud.pause_pressed.connect(_on_pause_pressed)

	load_phase(
		LISTAS_SCENE,
		Phase.build_all_stages()[0]
	)

func load_phase(scene: PackedScene, phase_data: Phase) -> void:
	if current_phase:
		current_phase.queue_free()

	current_phase = scene.instantiate()
	phase_container.add_child(current_phase)

	if current_phase.has_method("setup"):
		current_phase.setup(phase_data)

	if current_phase.has_method("undo"):
		gameplay_hud.undo_pressed.connect(current_phase.undo)

func _on_undo_pressed() -> void:
	if current_phase:
		current_phase.undo()

func _on_pause_pressed() -> void:
	get_tree().paused = true
	$PauseMenu.show()
