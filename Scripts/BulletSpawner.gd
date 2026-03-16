extends Node2D

var player : Player

func _ready() -> void:
	player = Global.get_player()
	player.player_combat.shoot.connect(spawn)


func spawn(bullet:PackedScene, direction:float , location:Vector2) -> void:
	var spawned_bullet : Bullet = bullet.instantiate()
	spawned_bullet.rotation = direction
	spawned_bullet.position = location
	
	add_child(spawned_bullet)
	spawned_bullet.shoot(direction)
