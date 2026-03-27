extends Area2D
class_name SceneTransitioner

@export var message : String = "write \n here what you \n need to do to win"
@export var msg_label : Label

@export var scene_to_transition_to : PackedScene
var player_in : bool = false


func _ready() -> void:
	msg_label.text = message

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in = true
		$AnimationPlayer.play("fade_in")
		

func _input(event: InputEvent) -> void:
	if player_in:
		if event is InputEvent:
			if event.is_action_pressed("Enter"):
				if scene_to_transition_to:
					get_tree().change_scene_to_packed(scene_to_transition_to)


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in = false
		$AnimationPlayer.play_backwards("fade_in")
