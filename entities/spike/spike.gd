extends Area2D
class_name Spike

signal player_hit

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _on_body_entered(body: Node2D) -> void:
	set_deferred("monitoring", false)
	if body is Player: player_hit.emit()
