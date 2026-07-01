extends CanvasLayer

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var _transitioning := false

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

	sprite.play("cobrir")
	await sprite.animation_finished
	
	var packed : PackedScene = ResourceLoader.load(scene_path)
	get_tree().change_scene_to_packed(packed)
	
	sprite.play("mostrar")
	await sprite.animation_finished

	_finish()

#func _change_when_loaded(scene_path: String) -> void:
	#while true:
		#var status := ResourceLoader.load_threaded_get_status(scene_path)
#
		#match status:
			#ResourceLoader.THREAD_LOAD_LOADED:
				#var packed := ResourceLoader.load_threaded_get(scene_path)
				#get_tree().change_scene_to_packed(packed)
				#await get_tree().process_frame
				#return
#
			#ResourceLoader.THREAD_LOAD_FAILED:
				#push_error("Falha ao carregar: %s" % scene_path)
				#return
#
		#await get_tree().process_frame

func _finish() -> void:
	sprite.visible = false
	sprite.frame = 0
	_transitioning = false
	get_tree().paused = false
