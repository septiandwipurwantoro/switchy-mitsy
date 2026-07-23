@tool
extends Node2D
class_name Platform

@export var platform_index := 0:
	set(value):
		platform_index = value
		_update_visual()
		
@export var size := Vector2(48.0, 48.0):
	set(value):
		size = value
		_update_visual()

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var color_rect: ColorRect = $ColorRect

var color_code := [
	Color.RED,
	Color.GREEN,
	Color.BLUE
]

func _ready():
	_update_visual()

func _update_visual():
	if !is_node_ready():
		return

	color_rect.size = size
	color_rect.position = -size / 2.0
	color_rect.color = color_code[platform_index]

	if collision_shape_2d.shape is RectangleShape2D:
		collision_shape_2d.shape.size = size

func update_existence(appeared_turn: int, platform_group_total: int) -> void:
	var queue_distance: int
	if appeared_turn >= platform_index: queue_distance = appeared_turn - platform_index
	else: queue_distance = platform_group_total - platform_index + appeared_turn

	if platform_group_total > 1:
		var transparant := float(queue_distance) / float(platform_group_total - 1)
		transparant = pow(transparant, 2.0)
		color_rect.color.a = lerp(1.0, 0.1, transparant)
	else:
		color_rect.color.a = 1.0

	collision_shape_2d.disabled = queue_distance != 0
