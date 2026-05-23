extends Control

class_name TutorialIndicator

@export var filled_icon: Texture2D
@export var outline_icon: Texture2D

@onready var icon: TextureRect = $Icon

func set_active(value: bool):
	icon.texture = filled_icon if value else outline_icon
