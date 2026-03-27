extends Node2D

@onready var animation = $AnimationPlayer
@export var direction : Vector2 = Vector2.RIGHT
@export var force = 1000
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		animation.play("hand_push")
		body.apply_force(direction, force)
