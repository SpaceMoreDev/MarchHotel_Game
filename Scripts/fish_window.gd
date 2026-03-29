extends Control
class_name FishWindow

@export var fish_sprite : AnimatedSprite2D
@export var fish_name : Label
@export var fish_creator : Label
@export var fish_value : Label

signal OnWindowClose()
signal OnWindowOpen()

func show_window():
	visible = true
	OnWindowOpen.emit()

func hide_window():
	visible = false
	OnWindowClose.emit()

func set_fish_data(fish : Fish):
	fish_sprite.sprite_frames = fish.frames
	fish_name.text = fish.name
	if fish.rarity == Fish.RARITY.COMMON:
		fish_name.add_theme_color_override("font_color", Color.GREEN)
	elif fish.rarity == Fish.RARITY.RARE:
		fish_name.add_theme_color_override("font_color", Color.BLUE)
	elif fish.rarity == Fish.RARITY.EPIC:
		fish_name.add_theme_color_override("font_color", Color.PURPLE)
	
	fish_creator.text = fish.creator
	fish_value.text = str(int(fish.value))

func _on_button_gui_input(event: InputEvent) -> void:
	if visible:
		if event is InputEventMouseButton:
			if event.is_pressed():
				hide_window()
