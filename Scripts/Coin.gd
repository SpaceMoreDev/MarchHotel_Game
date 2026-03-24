extends Area2D
class_name Coin

var target : Vector2
var player : Player
var picked= false
var active = false
var speed := 500.0

func _ready() -> void:
	player = Global.get_player()

func throw():
	picked= false
	monitoring = true

func lifetime_ended():
	miss()
	reset()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if picked:
		var world_target = Global.get_coin_UI_pos()
		position = position.move_toward(world_target, speed * delta)
	elif active:
		position = position.move_toward( position+(Vector2.DOWN*100) , speed*delta)
		if position.y > 780:
			lifetime_ended()
	


func _on_body_entered(body: Node2D) -> void:
	if picked:
		return
	
	if not body is Player:
		return
	
	collect()
	#create_tween().tween_property(self,"global_scale",Vector2.ZERO,1)
	var tween : Tween = create_tween()
	tween.tween_property(self,"modulate",Color(1,1,1,0),.6).finished.connect(reset)

	Global.add_coins_count(1)
	
	picked = true
	pass

func miss():
	if active:
		Global.OnLoseHeatlh.emit(1)

func collect():
	#if active:
		#Global.OnGainHeatlh.emit(1)
	pass

func reset():
	visible = false
	active = false
	picked= false
	monitoring = false
	modulate = Color.WHITE
