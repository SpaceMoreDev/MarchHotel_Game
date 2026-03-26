extends Resource
class_name Fish

enum RARITY
{
	COMMON,
	RARE,
	EPIC
}

@export var name : String
@export var creator : String
@export var rarity : RARITY
@export var value : float = 1
@export var frames : SpriteFrames
