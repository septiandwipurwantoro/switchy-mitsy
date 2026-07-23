extends Node

const SAVE_PATH := "user://savegame.data"

@export var data_list: Array[SaveData]

func save_game() -> void:
	var context: Dictionary[String, Dictionary] = {}
	for save_data in data_list:
		context[save_data.name] = save_data.data

	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if not file: 
		push_error("SaveManager: gagal membuka file untuk menulis (%s)" % SAVE_PATH)
		return

	file.store_var(context)
	file.close()

func load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH): return

	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		push_error("SaveManager: gagal membuka file untuk membaca (%s)" % SAVE_PATH)
		return

	var context: Dictionary = file.get_var()
	file.close()

	for save_data in data_list:
		if context.has(save_data.name):
			save_data.set_all_data(context[save_data.name])

func get_save_data(name: String) -> SaveData:
	for save_data in data_list:
		if save_data.name == name: return save_data
			
	return null
