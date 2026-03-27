extends Combat
class_name EnemyCombat

var firing_actor : Goblin
var bullet_spawner : BulletSpawner


func _ready() -> void:
	firing_actor = get_parent() as Goblin
	bullet_spawner = get_tree().get_first_node_in_group("BulletSpawner")
	shoot.connect(bullet_spawner.spawn)

func fire(dir) -> void:
	if not firing_actor.dead or firing_actor.active:
		shoot.emit(dir, firing_actor)
