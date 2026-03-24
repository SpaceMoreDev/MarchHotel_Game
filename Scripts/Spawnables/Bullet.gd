extends Area2D
class_name Bullet

var velocity = Vector2.ZERO
var dir : Vector2
var active : bool = false
var speed = 700

var moving = false
var timer : Timer
var hit = false
@export var firing_actor : Variant

func _ready() -> void:
	timer = Timer.new()
	timer.one_shot = true
	timer.timeout.connect(explode)
	add_child(timer)
	pass

func shoot(new_dir : float, _firing_actor) -> void:
	timer.stop()
	firing_actor = _firing_actor
	$Sprite2D.play("Idle")
	
	velocity = Vector2.RIGHT.rotated(new_dir)
	
	if velocity.x > 0:
		$Sprite2D.flip_h = false
	else:
		$Sprite2D.flip_h = true

	moving = true
	#set_physics_process(true)

	timer.start(3.0) # lifetime

# Called every frame. 'delta' is the elaaaaaaadfffdfpsed time since the previous frame.
func _process(delta: float) -> void:
	if moving:
		if firing_actor:
			global_position += velocity * speed * delta


func _on_body_entered(body: Node2D) -> void:
	if not active:
		return
		
	if not body is Character:
		return

	if (body as Character).dead:
		return
	
	if firing_actor is Goblin:
		if body is Goblin:
			return
	else:
		if firing_actor is Player:
			if body is Player:
				return
	
	if firing_actor:
		if body == firing_actor:
			return
		
		if body is Character:
			body.take_damage(firing_actor)
	
	
	explode()

func explode():
	moving = false
	timer.stop()
	active = false
	
	if $Sprite2D.is_playing():
		$Sprite2D.play("explode")
		await $Sprite2D.animation_finished
	
	#set_physics_process(false)
	visible = false
	firing_actor = null
	global_position = Vector2(-200,-600)
	
	
