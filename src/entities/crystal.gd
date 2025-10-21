@tool class_name Crystal extends Area2D

@export var connected_color_source: Node2D
@onready var req1 = %Req1
@onready var req2 = %Req2

var complete1 = false
var complete2 = false

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		if connected_color_source:
			connected_color_source.global_position = global_position

# 0.3 is good threshold! 
func are_colors_similar(color1: Color, color2: Color, threshold := 1) -> bool:
	var dr = color1.r - color2.r
	var dg = color1.g - color2.g
	var db = color1.b - color2.b
	var distance = sqrt(dr * dr + dg * dg + db * db)
	return distance < threshold

func color_allowed(pcolor: Color) -> bool:
	print("checking p color:", pcolor)
	if !complete1:
		for child in req1.get_children():
			if not child.visible:
				print("not visible")
				continue
			if child.has_method("color_value"):
				var child_color = child.color_value()
				if are_colors_similar(pcolor, child_color):
					req1.visible = false
					complete1 = true
					return true
	if !complete2:
		for child in req2.get_children():
			if not child.visible:
				print("not visible")
				continue
			if child.has_method("color_value"):
				var child_color = child.color_value()
				if are_colors_similar(pcolor, child_color):
					req2.visible = false
					complete2 = true
					return true
	return false
	
func full() -> bool:
	if !req2.visible and !req1.visible:
		return true 
	return false
