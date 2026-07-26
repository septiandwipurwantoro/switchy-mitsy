@tool
extends Area2D
class_name Spike

signal player_hit

@export var in_count_down := true:
	set(value):
		in_count_down = value
		_update_visual()

@export var spike_index := 0:
	set(value):
		spike_index = value
		_update_visual()

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var spike_sprite: TextureRect = $SpikeSprite

func _ready() -> void:
	_update_visual()

func _on_body_entered(body: Node2D) -> void:
	if body is Player: player_hit.emit()

func disable() -> void:
	collision_shape_2d.disabled = true
	
func _update_visual():
	if !is_node_ready():
		return
	
	if in_count_down: spike_sprite.self_modulate = Platform.COLOR_CODE[spike_index]
	else: spike_sprite.self_modulate = Color.WHITE
	
func update_existence(appeared_turn: int, spike_group_total: int) -> void:
	if not in_count_down: return
	
	var queue_distance: int
	if appeared_turn >= spike_index: queue_distance = appeared_turn - spike_index
	else: queue_distance = spike_group_total - spike_index + appeared_turn

	if spike_group_total > 1:
		var transparant := float(queue_distance) / float(spike_group_total - 1)
		spike_sprite.modulate.a = lerp(1.0, 0.1, transparant)
	else: spike_sprite.modulate.a = 1.0

	collision_shape_2d.disabled = queue_distance != 0
