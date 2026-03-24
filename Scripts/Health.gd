extends Node
class_name Health

var health_points : int

class Heart:
	var node: Control
	var valid : bool = true
	
	func remove():
		self.valid = false
		self.node.modulate = Color.TRANSPARENT
	
	func add():
		self.valid = true
		self.node.modulate = Color.WHITE

var hearts : Array[Heart]

func _ready() -> void:
	Global.OnGainHeatlh.connect(add_health)
	Global.OnLoseHeatlh.connect(remove_health)
	
	for node in get_children():
		#print(node.name)
		
		var h = Heart.new()
		h. valid = node.visible
		h.node = node
		hearts.push_front(h)
	
	health_points = hearts.size()


func remove_health(value : int = 1):
	var new_hp = health_points - value
	#print('lost ' + str(health_points) + ' - ' + str(value) + ' = ' + str(new_hp))
	health_points = clamp(new_hp, 0, hearts.size())
	#print("----> clamped hp: " + str(health_points))
	var index = health_points
	hearts[index].remove()
	
	check_gameover(new_hp)

func add_health(value : int = 1):
	var new_hp = health_points + value
	#print('gain ' + str(health_points) + ' + ' + str(value) + ' = ' + str(new_hp))
	health_points = clamp(new_hp, 0, hearts.size())
	#print("----> clamped hp: " + str(health_points))
	var index = health_points-1
	hearts[index].add()

func check_gameover(hp):
	if hp <= 0:
		#print('game over')
		Global.go_to_hub()
