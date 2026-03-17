extends Node
var coins : int = 0
var chosen_character_data : Character_Data

var checkpoint_location : Vector2

signal OnCharacterSelection(activatedSlot : CharacterSlot)
signal OnCharacterHover(slot : CharacterSlot)


func get_player() -> Player:
	var player
	player = get_tree().get_first_node_in_group("Player")
	return player
 
func get_bullet_spawner() -> Node2D:
	return get_tree().get_first_node_in_group("BulletSpawner")
 

func get_coin_UI_pos() -> Vector2:
	var player = get_player()
	
	if not player:
		return Vector2.ZERO
	
	var screen_pos = player.coin_icon.get_rect().position
	var world_target = get_viewport().get_canvas_transform().affine_inverse() * screen_pos
	return world_target

func add_coins_count(count:int):
	var player = get_player()
	
	if not player:
		return
	
	coins+=count
	player.coin_text.text = str(coins)
	
	#var tween = get_tree().create_tween()
	#
	#tween.tween_property(player.coin_icon, "scale", Vector2(0.7, 0.7), 0.2) \
	#.set_trans(Tween.TRANS_SPRING) \
	#.set_ease(Tween.EASE_IN_OUT)
	#
	#tween.tween_property(player.coin_icon, "scale", Vector2(1.0, 1.0), 0.1) \
	#.set_ease(Tween.EASE_IN_OUT)

func Death():
	var player = get_player()
	if player:
		player.position = checkpoint_location

func set_player_data(data : Character_Data):
	chosen_character_data = data
	var player = get_player()
	if player:
		player.set_character(data)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Debug_MiniA"):
		get_tree().change_scene_to_file("res://Characters Data/minigame_A.tscn")
	if event.is_action_pressed("Debug_HUB"):
		get_tree().change_scene_to_file("res://main.tscn")
