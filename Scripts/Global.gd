extends Node
var coins : int = 0
var chosen_character_data : Character_Data
var checkpoint_location : Vector2
var collected_fishes : Array[Fish]

signal OnCharacterSelection(activatedSlot : CharacterSlot)
signal OnCharacterHover(slot : CharacterSlot)
signal OnLoseHeatlh(amount : int)
signal OnGainHeatlh(amount : int)

func _ready() -> void:
	load_data()
	get_tree().scene_changed.connect(onchangescene)

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

func onchangescene():
	var player = get_player()
	
	if not player:
		return
	(player as Player).coin_text.text = str(coins)

func add_coins_count(count:int):
	var player = get_player()
	
	if not player:
		return
	
	coins+=count
	player.coin_text.text = str(coins)
	save_data()
	#var tween = get_tree().create_tween()
	#
	#tween.tween_property(player.coin_icon, "scale", Vector2(0.7, 0.7), 0.2) \
	#.set_trans(Tween.TRANS_SPRING) \
	#.set_ease(Tween.EASE_IN_OUT)
	#
	#tween.tween_property(player.coin_icon, "scale", Vector2(1.0, 1.0), 0.1) \
	#.set_ease(Tween.EASE_IN_OUT)

func save_data():
	var config = ConfigFile.new()
	config.set_value("player", "coins", coins)
	config.save("user://save.cfg")

func load_data():
	var config = ConfigFile.new()
	var err = config.load("user://save.cfg")
	
	if err == OK:
		coins = config.get_value("player", "coins", 0)

func Death():
	var player = get_player()
	if player:
		player.position = checkpoint_location

func set_player_data(data : Character_Data):
	chosen_character_data = data
	var player = get_player()
	if player:
		player.set_character(data)

func go_to_hub():
	get_tree().call_deferred("change_scene_to_file", "res://main.tscn")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Debug_MiniA"):
		get_tree().change_scene_to_file("res://Scenes/minigame_A.tscn")
	if event.is_action_pressed("Leave"):
		if get_tree().current_scene.name != "Main" :
			go_to_hub()
	if event.is_action_pressed("Debug_fishing"):
		get_tree().change_scene_to_file("res://Scenes/minigameB_fishing.tscn")
	if event.is_action_pressed("Debug_backstreet"):
		get_tree().change_scene_to_file("res://Scenes/backstreet.tscn")
