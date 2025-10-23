class_name Orb extends Node2D

@export var color_change_duration: float = 1.0;
@export var scale_change_duration: float = 0.5;
@export var absorb_threshold: float = 5.0;

@export var curvy: Curve

@onready var sprite: Sprite2D = $Sprite2D

var _getting_absorbed: bool = false
var _player: CharacterBody2D
var _player_sprite: Sprite2D
var _initial_distance: float
var _color_tween: Tween
var _scale_tween: Tween

@export var OnCollectSFX: PackedScene

# Textures
var _id: int = 0
var _circle: Texture2D = load("res://Art/aura_circle.png")
var _square: Texture2D = load("res://Art/aura_square.png")
var _diamond: Texture2D = load("res://Art/aura_diamond.png")
var _x: Texture2D = load("res://Art/aura_x.png")
var _heart: Texture2D = load("res://Art/aura_heart.png")
var _textures: Array[Texture2D] = [_circle, _square, _diamond, _x, _heart]

var _circle_fill: Texture2D = load("res://Art/aura_circle_fill.png")
var _square_fill: Texture2D = load("res://Art/aura_square_fill.png")
var _diamond_fill: Texture2D = load("res://Art/aura_diamond_fill.png")
var _x_fill: Texture2D = load("res://Art/aura_x_fill.png")
var _heart_fill: Texture2D = load("res://Art/aura_heart_fill.png")
var _textures_fill: Array[Texture2D] = [_circle_fill, _square_fill, _diamond_fill, _x_fill, _heart_fill]


func _ready() -> void:
	var time_now = Time.get_unix_time_from_system() # replaces OS.get_unix_time() in Godot 4
	var seed_value = int(floor(time_now / 100000))
	seed(seed_value)
	randomize()
	var colors: Array[Color] = []
	for i in range(5):
		var hue = float(i) / 5
		var color = Color.from_ok_hsl(hue, 0.75, 0.5)
		colors.append(color)
	_id = randi() % colors.size()
	sprite.modulate = colors[_id]
	sprite.texture = _textures[_id]



func _process(_delta: float) -> void:
	if _getting_absorbed:
		if _color_tween.is_running() && _scale_tween.is_running():
			var current_fraction_complete = _color_tween.get_total_elapsed_time() / color_change_duration
			#print(current_fraction_complete)
			var current_distance = _initial_distance * curvy.sample(1 - current_fraction_complete)
			#print(current_distance)
			global_position = _player.global_position + (position - _player.global_position).normalized() * current_distance
		else:
			_kill() # I have been aborbed


func _exp_decay(a: float, b: float, decay: float, delta) -> float:
	return b + (a - b) * exp(-decay * delta)


func start_absorbtion(player: CharacterBody2D) -> void:
	_player = player
	_player_sprite = player.get_node("Sprite2D")
	_player_sprite.texture = _textures_fill[_id]
	_initial_distance = global_position.distance_to(_player.global_position)
	_color_tween = get_tree().create_tween().bind_node(self)
	_scale_tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN)
	_color_tween.tween_property(_player_sprite, "modulate", sprite.modulate, color_change_duration);
	_scale_tween.tween_property(sprite, "scale", Vector2.ZERO, scale_change_duration);
	_getting_absorbed = true
	var SFX: AudioStreamPlayer = OnCollectSFX.instantiate()
	get_parent().add_child(SFX)
	SFX.play()


func _kill() -> void:
	self.queue_free()


func color_value() : 
	print(sprite.modulate)
	return sprite.modulate
