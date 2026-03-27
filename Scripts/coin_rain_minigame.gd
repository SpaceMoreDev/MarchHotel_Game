extends Node

@export var mocking_bird : AnimatedSprite2D

@export var health : Health

var player : Player
var coinScene = preload("res://Scenes/coin.tscn")

var spawn_points : Array[AnimatedSprite2D]

var coin_pool : Array[Coin] = []
var timer : Timer


const POOL_SIZE := 10

func _mocking_bird():
	mocking_bird.play("laugh")
	await mocking_bird.animation_finished
	mocking_bird.play("idle")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.OnLoseHeatlh.connect(LoseHealth)
	player = Global.get_player()
	if player:
		player.camera.enabled = false
	
	for child in get_children():
		if child is AnimatedSprite2D:
			child.play("idle")
			spawn_points.append(child)
	
	
	for i in POOL_SIZE:
		var coin : Coin = coinScene.instantiate()
		coin.visible = false
		coin.active = false
		coin.picked = false
		coin.monitoring = false

		add_child(coin)
		coin_pool.append(coin)
	
	timer = Timer.new()
	timer.wait_time = 1
	timer.one_shot = true
	timer.timeout.connect(_timer_timeout)
	add_child(timer)
	timer.start()

func get_coin() -> Coin:
	for coin in coin_pool:
		if !coin.active:
			return coin
	return null
	
func LoseHealth(amount):
	_mocking_bird()

func GainHealth(amount):
	if health:
		health.add_health(amount)

func _timer_timeout():
	if not spawn_points.is_empty():
		var rand = spawn_points.pick_random()
		rand.play("throw") 
		spawn(rand)
		#print("spawned coin")

func spawn(goblin) -> void:
	var spawned_coin := get_coin()

	if spawned_coin == null:
		return
		
	
	spawned_coin.global_position = goblin.global_position
	spawned_coin.visible = true
	spawned_coin.picked = false
	spawned_coin.active = false
	
	timer.stop()
	await get_tree().create_timer(1).timeout
	timer.start()
	goblin.play("idle")
	spawned_coin.active = true
	spawned_coin.throw()
	spawned_coin.monitoring = true
