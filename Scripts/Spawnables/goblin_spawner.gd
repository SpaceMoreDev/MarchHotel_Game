extends Pool
class_name GoblinSpawner

var random_locations_to_spawn : Array[Node2D]
var goblin_scene : PackedScene = preload("res://Scenes/goblin.tscn")
@export var coin_pool : Pool
@export var goblins_max = 3
@export var spawn_interval = 2.5

var spawn_timer : Timer

func init_pool( _packed_scene : PackedScene, _pool_size = POOL_SIZE) -> Array[Variant]:
	super(_packed_scene, _pool_size)
	for obj in object_pool:
		if obj is Goblin:
			obj.dead = true
			obj.set_collision(false)
			obj.call_deferred("reparent",get_parent())
			
			obj.OnDeath.connect(_on_spawned_goblin_death)
	return object_pool

func _on_spawned_goblin_death(node):
	coin_pool.spawn_from_pool(node)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_pool(goblin_scene, 15)
	
	for child in get_children():
		random_locations_to_spawn.append(child)
	
	spawn_timer = Timer.new()
	spawn_timer.autostart = true
	spawn_timer.wait_time = spawn_interval
	spawn_timer.timeout.connect(_spawn_goblin)
	add_child(spawn_timer)
	spawn_timer.start()
	
	


func _spawn_goblin():
	if not random_locations_to_spawn.is_empty():
		var random = random_locations_to_spawn.pick_random()
		spawn(Vector2.RIGHT.angle(), random)

func get_pool_instance() -> Variant:
	for goblin in object_pool:
		if goblin is Goblin:
			if goblin.dead:
				return goblin
	return null

func get_goblins_in_scene() -> int:
	var goblins_ct = 0
	for goblin in object_pool:
		if not goblin.dead:
			goblins_ct+=1
	
	return goblins_ct

# Called every frame. 'delta' is the elapsed time since the previous frame.
func spawn(direction:float , target : Node2D) -> void:
	if get_goblins_in_scene() >= goblins_max:
		return
	
	var spawned_obj := get_pool_instance() as Goblin
	if spawned_obj == null:
		return
	
	
	var rand = RandomNumberGenerator.new()
	spawned_obj.random_speed_variation = rand.randf_range(0,70)
	spawned_obj.SPEED += spawned_obj.random_speed_variation
	spawned_obj.Sprite.play("Idle")
	spawned_obj.global_position = target.global_position
	spawned_obj.visible = true
	spawned_obj.dead = false
	spawned_obj.set_collision(true)
	
