extends Node

var crystals_filled: int = 0 # defaults to zero
var crystals_desired: int = 100 # assigned externally by Crystals script
var greyscale: ColorRect # assigned externally by GreyscaleColorFilter script

func fill_crystal() -> void:
	crystals_filled += 1
	if crystals_filled == crystals_desired:
		var sat_tween = create_tween()
		sat_tween.tween_property(greyscale, "material:shader_parameter/saturation", 1.0, 0.5)
		var bright_tween = create_tween()
		bright_tween.tween_property(greyscale, "material:shader_parameter/brightness", 1.0, 0.5)

func regray() -> void:
	greyscale.material.set_shader_parameter("saturation", 0.0)
	greyscale.material.set_shader_parameter("brightness", 0.29)
