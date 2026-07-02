extends Control

class_name TutorialManager

@export var steps: Array[TutorialStepResource]
@export var indicator_scene: PackedScene

@onready var overlay_bg = $OverlayBg
@onready var tutorial_content = $TutorialContent

@onready var title_label = $TutorialContent/MarginCtn/VBoxContainer/VBoxContainer2/Title
@onready var description_label = $TutorialContent/MarginCtn/VBoxContainer/VBoxContainer2/Description
@onready var image_rect = $TutorialContent/MarginCtn/VBoxContainer/VBoxContainer2/ImageRelated

@onready var prev_button = $TutorialContent/MarginCtn/VBoxContainer/Navigation/BackBtn
@onready var next_button = $TutorialContent/MarginCtn/VBoxContainer/Navigation/NextBtn
@onready var indicators_container = $TutorialContent/MarginCtn/VBoxContainer/Navigation/IndicadoresCtn
@onready var close_button = $TutorialContent/MarginCtn/VBoxContainer/Topbar/CloseTutorial

signal tutorial_closed

var current_step := 0

func _ready():
	build_indicators()
	hide()

func open_tutorial():
	show()
	current_step = 0
	show_step(current_step)

func close_tutorial():
	hide()
	tutorial_closed.emit()
	
func next_step():
	current_step += 1

	if current_step >= steps.size():
		close_tutorial()
		return

	show_step(current_step)
	
func back_step():
	current_step = max(current_step - 1, 0)

	show_step(current_step)
	
func show_step(index: int):
	var step = steps[index]

	title_label.text = step.title
	description_label.text = step.description
	image_rect.texture = step.image

	update_buttons()
	update_indicators()
	
func build_indicators():
	for child in indicators_container.get_children():
		child.queue_free()

	for i in range(steps.size()):
		var indicator = indicator_scene.instantiate()

		indicators_container.add_child(indicator)
		
func update_buttons():
	prev_button.visible = current_step > 0
		
func update_indicators():
	for i in range(indicators_container.get_child_count()):
		var indicator: TutorialIndicator = indicators_container.get_child(i)

		indicator.set_active(i == current_step)
