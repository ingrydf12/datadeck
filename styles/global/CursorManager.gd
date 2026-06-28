extends Node

var cursor_normal = preload("res://assets/interactions/cursor.png")
var cursor_can_click = preload("res://assets/interactions/can_click.png")
var cursor_click = preload("res://assets/interactions/click.png")
var cursor_pick = preload("res://assets/interactions/can_pick.png")
var cursor_picked = preload("res://assets/interactions/picked.png")

enum CursorType {
	NORMAL,
	CAN_CLICK,
	CLICK,
	PICK,
	PICKED
}

var cursor_scale := 3.0

func _ready():
	Input.set_custom_mouse_cursor(
		_escalar_cursor(cursor_normal),
		Input.CURSOR_ARROW,
		Vector2(0,0)
	)
	
	Input.set_custom_mouse_cursor(
		_escalar_cursor(cursor_can_click),
		Input.CURSOR_POINTING_HAND,
		Vector2(16,16)
	)
	
	Input.set_custom_mouse_cursor(
		_escalar_cursor(cursor_click),
		Input.CURSOR_POINTING_HAND,
		Vector2(16,16)
	)

	Input.set_custom_mouse_cursor(
		_escalar_cursor(cursor_pick),
		Input.CURSOR_DRAG,
		Vector2(16,16)
	)

	Input.set_custom_mouse_cursor(
		_escalar_cursor(cursor_picked),
		Input.CURSOR_DRAG,
		Vector2(16,16)
	)


func _escalar_cursor(texture: Texture2D) -> ImageTexture:
	var image := texture.get_image()

	image.resize(
		image.get_width() * cursor_scale,
		image.get_height() * cursor_scale,
		Image.INTERPOLATE_NEAREST
	)

	return ImageTexture.create_from_image(image)

func set_cursor(cursor:CursorType):
	if Engine.is_editor_hint():
		return

	match cursor:
		CursorType.NORMAL:
			Input.set_default_cursor_shape(Input.CURSOR_ARROW)
			
		CursorType.CAN_CLICK:
			Input.set_custom_mouse_cursor(
				_escalar_cursor(cursor_can_click),
				Input.CURSOR_POINTING_HAND,
				Vector2(16,16)
			)
			
		CursorType.CLICK:
			Input.set_custom_mouse_cursor(
				_escalar_cursor(cursor_click),
				Input.CURSOR_POINTING_HAND,
				Vector2(16,16)
			)

		CursorType.PICK:
			Input.set_custom_mouse_cursor(
				_escalar_cursor(cursor_pick),
				Input.CURSOR_DRAG,
				Vector2(16,16)
			)

		CursorType.PICKED:
			Input.set_custom_mouse_cursor(
				_escalar_cursor(cursor_picked),
				Input.CURSOR_DRAG,
				Vector2(16,16)
			)
