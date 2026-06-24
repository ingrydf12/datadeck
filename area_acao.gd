extends Area2D

signal mudar_array(operation : Operacao)

func _ready() -> void:
	HudCartas.connect("carta_jogada", _on_carta_jogada)

func _on_carta_jogada(carta : Carta):
	if not checar_colisao_no_ponto(get_global_mouse_position()):
		return
	
	if carta.dados:
		mudar_array.emit()

func checar_colisao_no_ponto(posicao_global: Vector2) -> Area2D:
	# 1. Obtém o estado atual da física da cena
	var space_state = get_world_2d().direct_space_state
		
	# 2. Configura os parâmetros do ponto de busca
	var query = PhysicsPointQueryParameters2D.new()
	query.position = posicao_global
	
	# IMPORTANTE: Use a collision_mask para filtrar apenas o que importa (seu campo de ação)
	# Se o seu campo de ação estiver na camada 2, coloque 2 aqui
	query.collision_mask = 1
	query.collide_with_areas = true
	
	# 3. Executa a consulta
	var result = space_state.intersect_point(query)
	
	# 4. Analisa o resultado
	if result.size() > 0:
		# result é uma lista de dicionários com informações da colisão
		# O collider é o objeto (Area2D) que foi atingido
		return result[0].collider

	return null # Nada atingido
