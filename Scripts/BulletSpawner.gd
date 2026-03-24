extends Pool
class_name BulletSpawner

var bulletScene = preload("res://Scenes/bullet.tscn")

func init_pool( _packed_scene : PackedScene, _pool_size = POOL_SIZE) -> Array[Variant]:
	super(_packed_scene, _pool_size)
	for obj in object_pool:
		if obj is Bullet:
			obj.active = false
			obj.moving = false
			obj.firing_actor = null
	return object_pool

func _ready() -> void:
	init_pool(bulletScene)

func get_pool_instance() -> Variant:
	for bullet in object_pool:
		if bullet is Bullet:
			if !bullet.active:
				return bullet
	return null
	
func spawn(direction:float , target : Node2D) -> void:
	super(direction, target)
	
	var spawned_bullet := get_pool_instance() as Bullet

	if spawned_bullet == null:
		return
	
	spawned_bullet.active = true
	spawned_bullet.shoot(direction, target)
	

	

	
