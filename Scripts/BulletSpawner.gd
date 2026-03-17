extends Node2D

var player : Player
var bulletScene = preload("res://Scenes/bullet.tscn")

var bullet_pool : Array[Bullet] = []
const POOL_SIZE := 20

func _ready() -> void:
	player = Global.get_player()
	player.player_combat.shoot.connect(spawn)

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
	
func spawn(direction:float , location:Vector2) -> void:
	var spawned_bullet := get_bullet()

	if spawned_bullet == null:
		return
	
	spawned_bullet.global_position = location
	spawned_bullet.visible = true
	spawned_bullet.active = true
	#spawned_bullet.set_physics_process(true)
	spawned_bullet.shoot(direction)
	

	

	
