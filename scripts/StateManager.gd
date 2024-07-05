extends Node


# Diccionario para almacenar el estado de cada zona
var zones_state = {}

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
