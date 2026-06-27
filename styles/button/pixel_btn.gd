extends TextureButton

@export var normal_color := Color.WHITE
@export var hover_color := Color(0.617, 0.617, 0.617, 1.0)
@export var pressed_color := Color(0.318, 0.318, 0.318, 1.0)
@export var disabled_color := Color(0.5, 0.5, 0.5)

func _ready():
	mouse_entered.connect(_on_hover)
	mouse_exited.connect(_on_exit)
	button_down.connect(_on_down)
	button_up.connect(_on_up)

func _on_hover():
	if !disabled:
		modulate = hover_color

func _on_exit():
	if !disabled:
		modulate = normal_color

func _on_down():
	if !disabled:
		modulate = pressed_color

func _on_up():
	if !disabled:
		modulate = hover_color if is_hovered() else normal_color
