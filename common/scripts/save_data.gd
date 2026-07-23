extends Resource
class_name SaveData

@export var name: String
@export var data: Dictionary[String, Variant]

func set_data(key: String, value: Variant) -> void: data[key] = value
func set_all_data(data: Dictionary[String, Variant]) -> void: self.data = data
