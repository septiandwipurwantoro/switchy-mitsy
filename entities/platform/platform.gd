@tool
extends Node2D
class_name Platform

@export var in_count_down := true:
	set(value):
		in_count_down = value
		_update_visual()

@export var platform_index := 0:
	set(value):
		platform_index = value
		_update_visual()
		
@export var size := Vector2(48.0, 48.0):
	set(value):
		size = value
		_update_visual()

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var platform_sprite: NinePatchRect = $PlatformSprite
@onready var platform_lines: TextureRect = $PlatformSprite/PlatformLines


const COLOR_CODE := [
	Color.RED,
	Color.GREEN,
	Color.BLUE,
	Color.YELLOW,
	Color.ORANGE,
	Color.PURPLE
]

func _ready():
	_update_visual()

func _update_visual():
	if !is_node_ready():
		return
	
	if in_count_down: platform_lines.modulate = COLOR_CODE[platform_index]
	else: platform_lines.modulate = Color.WHITE
	
	platform_sprite.size = size
	platform_sprite.position = -size / 2.0

	if collision_shape_2d.shape is RectangleShape2D:
		collision_shape_2d.shape.size = size

func update_existence(appeared_turn: int, platform_group_total: int) -> void:
	if not in_count_down: return
	
	var queue_distance: int
	if appeared_turn >= platform_index: queue_distance = appeared_turn - platform_index
	else: queue_distance = platform_group_total - platform_index + appeared_turn

	if platform_group_total > 1:
		var transparant := float(queue_distance) / float(platform_group_total - 1)
		platform_sprite.modulate.a = lerp(1.0, 0.1, transparant)
	else: platform_sprite.modulate.a = 1.0

	collision_shape_2d.disabled = queue_distance != 0
