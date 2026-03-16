extends Area2D
class_name Bullet

var velocity = Vector2.RIGHT
var dir : Vector2
var active : bool = false
var speed = 700

var explode_timer : Timer
var timer : Timer
var hit = false

func _ready() -> void:
	timer = Timer.new()
	timer.one_shot = true
	timer.timeout.connect(explode)
	add_child(timer)
	
	explode_timer = Timer.new()
	explode_timer.one_shot = true
	add_child(explode_timer)
	pass

func shoot(new_dir : float) -> void:
	$Sprite2D.show()
	$explode.hide()
	explode_timer.stop()
	
	velocity = Vector2.RIGHT.rotated(new_dir)
	
	if velocity.x > 0:
		$Sprite2D.flip_h = true
	else:
		$Sprite2D.flip_h = false

	active = true
	visible = true
	set_physics_process(true)

	timer.start(3.0) # lifetime

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if active:
		position += velocity * speed * delta


func _on_body_entered(body: Node2D) -> void:
	explode()
		
func explode():
	active = false
	
	$Sprite2D.hide()
	$explode.show() # explosion sprite
	
	explode_timer.start(.5)
	await explode_timer.timeout
	
	$Sprite2D.show()
	$explode.hide()
	
	set_physics_process(false)
	visible = false
	position = Vector2(99999,99999)	
	
	
	timer.stop()
	explode_timer.stop()
