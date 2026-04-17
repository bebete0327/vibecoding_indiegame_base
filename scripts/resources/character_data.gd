## 캐릭터 스탯 리소스 — Resource 패턴 예시.
## 에디터에서 .tres 파일로 저장하고 씬에 드래그하여 사용.
##
## 사용 예:
##   @export var data: CharacterData
##   func _ready() -> void:
##       health = data.max_health
##
## 새 리소스를 만들려면 FileSystem 패널에서 우클릭 → New Resource → CharacterData 선택.
class_name CharacterData
extends Resource

@export var display_name: String = ""
@export var max_health: int = 100
@export var move_speed: float = 200.0
@export var jump_velocity: float = -400.0
@export var attack_damage: int = 10
@export var sprite: Texture2D
@export var portrait: Texture2D
