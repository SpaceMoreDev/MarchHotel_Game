extends Node

@export var fishes : Array[Fish]
@export var bubbles : Node2D

@export var qte_bar : QTE_BAR
@export var fish_window : FishWindow

@export var min_limit : Vector2
@export var max_limit : Vector2

@export var min_wait : float = 1
@export var max_wait : float = 10

@export var max_bubbles_wait : float = 2


@export var common_chance : float = 0.70
@export var rare_chance   : float = 0.25
@export var epic_chance   : float = 0.05

const selection_pause : float = 1


var timer : Timer
var selected_fish : Fish

func stop_qte():
	qte_bar.active = false
	#await get_tree().create_timer(selection_pause).timeout
	$AnimationPlayer.play_backwards("fishing_bar_slide_in")
	#_start_bubbles_timer()

func on_qte_fail():
	stop_qte()
	_start_bubbles_timer()

func on_qte_success():
	timer.stop()
	stop_qte()
	fish_window.show_window()


func _start_bubbles_timer():
	get_tree().create_tween().tween_property(bubbles,"modulate:a",0,0.3)

	#bubbles.visible = false
	var rand = RandomNumberGenerator.new()
	timer.start(rand.randf_range(min_wait,max_wait))

func on_fish_window_close():
	Global.collected_fishes.append(selected_fish)
	Global.add_coins_count(selected_fish.value)
	_start_bubbles_timer()

func on_fish_window_open():
	fish_window.set_fish_data(selected_fish)


func _ready() -> void:
	fish_window.visible = false
	fish_window.OnWindowClose.connect(on_fish_window_close)
	fish_window.OnWindowOpen.connect(on_fish_window_open)
	qte_bar.OnFail.connect(on_qte_fail)
	qte_bar.OnSuccess.connect(on_qte_success)
	
	timer = Timer.new()
	timer.autostart = true
	timer.one_shot = true
	timer.timeout.connect(_time_out)
	add_child(timer)
	
	_start_bubbles_timer()
	#_time_out()

func _time_out():
	var pos = Vector2(
		randf_range(min_limit.x, max_limit.x),
		randf_range(min_limit.y, max_limit.y)
	)
	
	bubbles.position = pos
	#bubbles.visible = true
	get_tree().create_tween().tween_property(bubbles,"modulate:a",1,0.3)
	var rand = RandomNumberGenerator.new()
	await get_tree().create_timer(rand.randf_range(1, max_bubbles_wait)).timeout
	_start_bubbles_timer()


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if bubbles.modulate != Color.TRANSPARENT:
		if event is InputEventMouseButton:
			if event.is_pressed():
				bubbles.modulate = Color.TRANSPARENT
				qte_bar.active = true
				qte_bar.reset_qte()
				qte_bar.visible = true
				$AnimationPlayer.play("fishing_bar_slide_in")
				
				var rand_fish = get_random_fish_by_rarity()
				selected_fish = rand_fish

func get_random_fish_by_rarity() -> Fish:
	var roll = randf()
	
	var chosen_rarity : Fish.RARITY
	
	if roll < common_chance:
		chosen_rarity = Fish.RARITY.COMMON
	elif roll < common_chance + rare_chance:
		chosen_rarity = Fish.RARITY.RARE
	else:
		chosen_rarity = Fish.RARITY.EPIC
	
	var pool : Array[Fish] = []
	for fish in fishes:
		if fish.rarity == chosen_rarity:
			pool.append(fish)
	
	if pool.is_empty():
		return fishes.pick_random()
	
	return pool.pick_random()
