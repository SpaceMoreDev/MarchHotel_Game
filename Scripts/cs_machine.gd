extends Area2D

var character_selector : CharacterSelect
var is_in_range : bool = false

var player : Player 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	character_selector = get_tree().get_first_node_in_group("CharacterSelect_Menu")

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player = body
		is_in_range = true
		$AnimationPlayer.play("fade_in")

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		body.self_active = true
		is_in_range = false
		character_selector.deactivate()
		$AnimationPlayer.play_backwards("fade_in")

func _input(event: InputEvent) -> void:
	if is_in_range:
		if event.is_action_pressed("Enter"):
			player.self_active = false
			character_selector.activate()
