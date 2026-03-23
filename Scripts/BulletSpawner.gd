extends Node2D
class_name BulletSpawner

var bulletScene = preload("res://Scenes/bullet.tscn")

var bullet_pool : Array[Bullet] = []
const POOL_SIZE := 100

func _ready() -> void:
	for i in POOL_SIZE:
		var bullet : Bullet = bulletScene.instantiate()
		bullet.visible = false
		bullet.active = false
		bullet.moving = false
		#bullet.set_physics_process(false)
		#bullet.position = Vector2(99999,99999)
		add_child(bullet)
		bullet_pool.append(bullet)

func get_bullet() -> Bullet:
	for bullet in bullet_pool:
		if !bullet.active:
			return bullet
	return null
	
func spawn(direction:float , target : Node2D) -> void:
	var spawned_bullet := get_bullet()

	if spawned_bullet == null:
		return
	
	spawned_bullet.global_position = target.position
	spawned_bullet.visible = true
	spawned_bullet.active = true
	#spawned_bullet.set_physics_process(true)
	spawned_bullet.shoot(direction, target)
	

	

	
