extends Node

# Diccionario para almacenar el estado de cada zona
var zones_state = {}

# Diccionario para almacenar el estado de cada conocimiento
var knowledges_state = {}

# Diccionario para almacenar el estado de cada tipo de magia
var magic_state = {}

# Método para guardar el estado de una zona
func save_zone_state(zone_name: String, state_data: Dictionary) -> void:
	zones_state[zone_name] = state_data

# Método para cargar el estado de una zona
func load_zone_state(zone_name: String):
	if zone_name in zones_state:
		return zones_state[zone_name]
	else:
		return null

# Método para verificar si hay estado guardado de una zona
func has_zone_state(zone_name: String) -> bool:
	return zone_name in zones_state

# Método para guardar el estado de una zona
func save_knowledge_state(knowledge_name: String, state_data: Dictionary) -> void:
	knowledges_state[knowledge_name] = state_data

# Método para cargar el estado de una zona
func load_knowledge_state(knowledge_name: String):
	if knowledge_name in knowledges_state:
		return knowledges_state[knowledge_name]
	else:
		return null

# Método para verificar si hay estado guardado de una zona
func has_knowledge_state(knowledge_name: String) -> bool:
	return knowledge_name in knowledges_state

# Método para guardar el estado de una zona
func save_magic_state(magic_name: String, state_data: Dictionary) -> void:
	magic_state[magic_name] = state_data

# Método para cargar el estado de una zona
func load_magic_state(magic_name: String):
	if magic_name in magic_state:
		return magic_state[magic_name]
	else:
		return null

# Método para verificar si hay estado guardado de una zona
func has_magic_state(magic_name: String) -> bool:
	return magic_name in magic_state
