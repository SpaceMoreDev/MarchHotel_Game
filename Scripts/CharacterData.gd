extends Resource
class_name  Character_Data

enum ABILITY
{
	MELEE,
	RANGED
}

@export var name : String
@export var creator : String
@export var ability : ABILITY
@export var frames : SpriteFrames
@export var projectile_frames : SpriteFrames
