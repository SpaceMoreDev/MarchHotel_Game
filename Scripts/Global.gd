extends Node

var player : Player
var coins : int = 0
var chosen_character_data : Character_Data

signal OnCharacterSelection(activatedSlot : CharacterSlot)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

func get_player() -> Player:
	if !is_instance_valid(player):
		player = get_tree().get_first_node_in_group("Player")
	return player
 
func get_bullet_spawner() -> Node2D:
	return get_tree().get_first_node_in_group("BulletSpawner")
 

func get_coin_UI_pos() -> Vector2:
	if not player:
		return Vector2.ZERO
	
	var screen_pos = player.coin_icon.get_global_rect().position
	var world_target = get_viewport().get_canvas_transform().affine_inverse() * screen_pos
	return world_target

func add_coins_count(count:int):
	if not player:
		return
	
	coins+=count
	player.coin_text.text = str(coins)
	
	var tween = get_tree().create_tween()
	
	tween.tween_property(player.coin_icon, "scale", Vector2(0.7, 0.7), 0.2) \
	.set_trans(Tween.TRANS_SPRING) \
	.set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(player.coin_icon, "scale", Vector2(1.0, 1.0), 0.1) \
	.set_ease(Tween.EASE_IN_OUT)

func Death():
	coins = 0
	get_tree().reload_current_scene()
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://CharacterSelect.tscn")
