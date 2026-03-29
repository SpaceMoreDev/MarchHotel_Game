extends Control
class_name QTE_BAR

signal OnSuccess()
signal OnFail()

var t := 0.0
var speed := 1.2
var direction := 1
var success_range := Vector2(0.4, 0.6)
var active : bool = false
var waiting : bool = false

@export var label : Label
@export var progress_bar : ProgressBar
@export var min_width := 0.08
@export var max_width := 0.15

func reset_qte():
	if not active:
		return
	
	var width = randf_range(min_width, max_width)
	var half = width * 0.5
	var center = randf_range(half, 1.0 - half)
	
	success_range = Vector2(center - half, center + half)
	
	t = 0.0
	direction = 1
	
	progress_bar.material.set_shader_parameter("success_range", success_range)


func _ready() -> void:
	visible = false
	reset_qte()
	progress_bar.material.set_shader_parameter("success_range", success_range)

func _process(delta):
	if waiting or not active:
		return
	
	t += delta * speed * direction
	
	if t >= 1.0:
		t = 1.0
		direction = -1
	elif t <= 0.0:
		t = 0.0
		direction = 1
	
	progress_bar.material.set_shader_parameter("cursor_pos", t)
	progress_bar.material.set_shader_parameter("success_range", success_range)

func debug_name(txt : String):
	label.text = txt
	await get_tree().create_timer(.5).timeout
	label.text = ""

func _input(event):
	if not active:
		return
	if (event is InputEventMouseButton) or (event is InputEvent):
		if event.is_pressed():
			
			if t >= success_range.x and t <= success_range.y:
				print("success")
				
				OnSuccess.emit()
				visible = false
				debug_name("success")
			else:
				print("fail")
				OnFail.emit()
				debug_name("fail")
				active = false
			
			
			waiting = true
			await get_tree().create_timer(0.2).timeout
			waiting = false
			reset_qte()
