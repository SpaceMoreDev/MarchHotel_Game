extends Pool

var coin_scene : PackedScene = preload("res://Scenes/coin.tscn")

func init_pool( _packed_scene : PackedScene, _pool_size = POOL_SIZE) -> Array[Variant]:
	super(_packed_scene, _pool_size)
	for obj in object_pool:
		obj.visible = false
		obj.active = false
		obj.picked = false
		obj.monitoring = false
	return object_pool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_pool(coin_scene,20)


func get_pool_instance() -> Variant:
	for obj in object_pool:
		if obj is Coin:
			if !obj.visible:
				return obj
	return null

func spawn(direction:float , target : Node2D) -> void:
	var spawned_coin := get_pool_instance() as Coin

	if spawned_coin == null:
		return
		
	
	spawned_coin.global_position = target.global_position
	spawned_coin.visible = true
	spawned_coin.picked = false
	spawned_coin.monitoring = true
