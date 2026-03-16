extends Area2D
class_name Bullet

var velocity = Vector2.RIGHT
var dir : Vector2
var active : bool = false
var speed = 700

func shoot(new_dir : float) -> void:
	velocity = velocity.rotated(new_dir)
	active = true
	
	await get_tree().create_timer(3).timeout
	if active:
		explode()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if active:
		position += velocity * speed * delta


func _on_body_entered(body: Node2D) -> void:
	explode()
		
func explode():
	active = false
	$Sprite2D.hide()
	$explode.show() # can be particles later
	await get_tree().create_timer(.5).timeout
	queue_free()
