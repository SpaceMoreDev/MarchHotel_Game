extends Node
class_name PlayerCombat

var player : Player
var bulletScene = preload("res://Scenes/bullet.tscn")
signal shoot(bullet:PackedScene, direction:float , location:Vector2)

func _ready() -> void:
	player = Global.get_player()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Attack"):
		
		var dir = 0
		if player.Sprite.flip_h:
			dir =  Vector2.LEFT.angle()
		else:
			dir = Vector2.RIGHT.angle()
		
		shoot.emit(bulletScene, dir, player.position)
