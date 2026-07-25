@tool
extends StaticBody2D
class_name SpikedPlatform

signal player_hit

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var platform_sprite: ColorRect = $PlatformSprite
@onready var spike_collision: CollisionShape2D = $Spikes/SpikeArea/SpikeCollision
@onready var spike_sprite: NinePatchRect = $Spikes/SpikeSprite

@export var size := Vector2(48.0, 48.0):
	set(value):
		size = value
		_update_visual()

const SPIKE_WIDTH := Vector2(24, 24)

func _update_visual():
	if !is_node_ready():
		return
	
	platform_sprite.size = size
	platform_sprite.position = -size / 2.0
	collision_shape_2d.shape.size = size
		
	spike_sprite.size = size + SPIKE_WIDTH
	spike_sprite.position = -(size + SPIKE_WIDTH) / 2.0
	spike_collision.shape.size = size + SPIKE_WIDTH

func _on_spike_area_body_entered(body: Node2D) -> void:
	if body is Player: player_hit.emit()
