extends Area2D
class_name Coin

var target : Vector2
var player : Player
var picked= false
var active = false
var timer : Timer
var speed := 500.0

func _ready() -> void:
	timer = Timer.new()
	timer.one_shot = true
	timer.timeout.connect(lifetime_ended)
	add_child(timer)
	
	player = Global.get_player()

func throw():
	picked= false
	timer.start(3)

func lifetime_ended():
	reset()
	print("done")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if picked:
		var world_target = Global.get_coin_UI_pos()
		position = position.move_toward(world_target, speed * delta)
	elif active:
		position = position.move_toward( position+(Vector2.DOWN*100) , speed*delta)
	
	pass


func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Player"):
		return
	timer.stop()

	#create_tween().tween_property(self,"global_scale",Vector2.ZERO,1)
	var tween : Tween = create_tween()
	tween.tween_property(self,"modulate",Color(1,1,1,0),.6).finished.connect(reset)

	if player:
		Global.add_coins_count(1)
	picked = true
	pass
	
func reset():
	timer.stop()
	visible = false
	active = false
	picked= false
	modulate = Color.WHITE
	pass
