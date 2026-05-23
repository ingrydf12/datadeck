extends CanvasLayer

class_name TutorialManager

@export var steps: Array[TutorialStepResource]
@export var indicator_scene: PackedScene

@onready var overlay_bg = $OverlayBg
@onready var tutorial_control = $TutorialControl
@onready var tutorial_content = $TutorialControl/TutorialContent

@onready var title_label = $TutorialControl/TutorialContent/MarginCtn/VBoxContainer/VBoxContainer2/Title
@onready var description_label = $TutorialControl/TutorialContent/MarginCtn/VBoxContainer/VBoxContainer2/Description
@onready var image_rect = $TutorialControl/TutorialContent/MarginCtn/VBoxContainer/ImageRelated

@onready var prev_button = $TutorialControl/TutorialContent/MarginCtn/VBoxContainer/Navigation/BackBtn
@onready var next_button = $TutorialControl/TutorialContent/MarginCtn/VBoxContainer/Navigation/NextBtn
@onready var indicators_container = $TutorialControl/TutorialContent/MarginCtn/VBoxContainer/Navigation/IndicadoresCtn
@onready var close_button = $TutorialControl/TutorialContent/MarginCtn/VBoxContainer/Topbar/CloseTutorial

var current_step := 0

func _ready():
	tutorial_control.show()

	build_indicators()

	next_button.pressed.connect(next_step)
	prev_button.pressed.connect(back_step)
	close_button.pressed.connect(close_tutorial)

	show_step(current_step)

func open_tutorial():
	current_step = 0

	tutorial_control.show()

	show_step(current_step)
	
func close_tutorial():
	tutorial_control.hide()
	
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
