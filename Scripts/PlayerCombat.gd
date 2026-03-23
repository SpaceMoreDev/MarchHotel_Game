extends Combat
class_name PlayerCombat

var player : Player
var bullet_spawner : BulletSpawner

func _ready() -> void:
	player = Global.get_player()
	bullet_spawner = get_tree().get_first_node_in_group("BulletSpawner")
	if bullet_spawner:
		shoot.connect(bullet_spawner.spawn)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Attack"):
		
		var dir = 0
		if player.Sprite.flip_h:
			dir =  Vector2.LEFT.angle()
		else:
			dir = Vector2.RIGHT.angle()
		
		shoot.emit(dir, player)
