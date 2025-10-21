class_name Orb extends Node2D

@export var color_change_duration: float = 1.0;
@export var scale_change_duration: float = 0.5;
@export var position_change_speed: float =  16;

@onready var sprite: Sprite2D = $Sprite2D

var _getting_absorbed: bool = false
var _player: CharacterBody2D
var _player_sprite: Sprite2D
var _tween: Tween


func _ready() -> void:
	var hue: float = randf()
	var sat: float = randf_range(0.7, 1.0)
	var val: float = randf_range(0.8, 1.0)
	sprite.modulate = Color.from_hsv(hue, sat, val, 1.0)
	#var color: Color = Color.from_ok_hsl(1.5, 0.85, 0.75, 1.0)
	#var foat = color.
	

func _process(_delta: float) -> void:
	if _getting_absorbed && !_tween.is_running():
		kill() # I have been aborbed


func start_absorbtion(player: CharacterBody2D) -> void:
	_player = player
	_player_sprite = player.get_node("Sprite2D")
	_tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_ELASTIC)
	_tween.tween_property(_player_sprite, "modulate", sprite.modulate, color_change_duration);
	_tween.tween_property(sprite, "scale", Vector2.ZERO, scale_change_duration);
	_getting_absorbed = true


func kill() -> void:
	_getting_absorbed = false
	self.queue_free() 
