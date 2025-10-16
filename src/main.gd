class_name Main extends Node

@export var game_scene: PackedScene

var _game: Node2D


func _ready() -> void:
	_load_game()


func _load_game() -> void:
	_game = SceneManager.load_scene(self, game_scene)
