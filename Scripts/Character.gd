extends CharacterBody2D
class_name Character

signal OnDeath(node)
var dead = false

func death():
	if not dead:
		OnDeath.emit(self)
		dead = true
	#print("dead")

func take_damage(attacker : Character):
	pass
