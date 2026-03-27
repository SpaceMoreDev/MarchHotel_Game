extends Combat
class_name PlayerCombat

var player : Player
var bullet_spawner : BulletSpawner

func _ready() -> void:
	player = Global.get_player()
	bullet_spawner = get_tree().get_first_node_in_group("PlayerBulletSpawner")
	if bullet_spawner:
		shoot.connect(bullet_spawner.spawn)

func _reset_attack():
	player.is_attacking = true
	await get_tree().create_timer(.7).timeout
	player.is_attacking = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Attack"):
		
		player.Sprite.play("Cast")
		if not player.is_attacking:
			_reset_attack()
		
		var dir = 0
		if player.Sprite.flip_h:
			dir =  Vector2.LEFT.angle()
		else:
			dir = Vector2.RIGHT.angle()
		
		shoot.emit(dir, player)
