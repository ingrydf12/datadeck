extends CanvasLayer

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var frame_time := 0.05
var _transitioning := false

const CHANGE_SCENE_FRAME := 6

func _ready():
	layer = 100
	process_mode = Node.PROCESS_MODE_ALWAYS
	sprite.visible = false
	sprite.frame = 0

func play_transition(scene_path: String) -> void:
	if _transitioning:
		return

	if not ResourceLoader.exists(scene_path):
		push_error("Cena não encontrada: %s" % scene_path)
		return

	_transitioning = true

	sprite.visible = true
	sprite.frame = 0

	# Começa a carregar a cena em segundo plano
	var err := ResourceLoader.load_threaded_request(scene_path)

	if err != OK:
		push_error("Erro ao iniciar carregamento: %s" % scene_path)
		_finish()
		return

	await _animate(scene_path)

	_finish()

func _animate(scene_path: String) -> void:
	var anim := sprite.animation
	var total := sprite.sprite_frames.get_frame_count(anim)

	for i in range(total):
		sprite.frame = i

		if i == CHANGE_SCENE_FRAME:
			await _change_when_loaded(scene_path)

		await get_tree().create_timer(frame_time).timeout

func _change_when_loaded(scene_path: String) -> void:
	while true:
		var status := ResourceLoader.load_threaded_get_status(scene_path)

		match status:
			ResourceLoader.THREAD_LOAD_LOADED:
				var packed := ResourceLoader.load_threaded_get(scene_path)
				get_tree().change_scene_to_packed(packed)
				await get_tree().process_frame
				return

			ResourceLoader.THREAD_LOAD_FAILED:
				push_error("Falha ao carregar: %s" % scene_path)
				return

		await get_tree().process_frame

func _finish() -> void:
	sprite.visible = false
	sprite.frame = 0
	_transitioning = false
	get_tree().paused = false
