extends Area2D

var target : Vector2
var player : Player
var activated = false

var speed := 500.0

func _ready() -> void:
	player = Global.get_player()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if activated:
		var world_target = Global.get_coin_UI_pos()
		position = position.move_toward(world_target, speed * delta)
		
	pass


func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Player"):
		return
	
	activated = true
	#create_tween().tween_property(self,"global_scale",Vector2.ZERO,1)
	create_tween().tween_property(self,"modulate",Color(1,1,1,0),.6).set_ease(Tween.EASE_IN_OUT).finished.connect(TweenFinished)
	
	if player:
		Global.add_coins_count(1)
	
	pass
	
func TweenFinished():
	queue_free()
	pass
