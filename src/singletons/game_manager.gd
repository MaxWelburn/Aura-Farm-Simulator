extends Node

var crystals_filled: int = 0 # defaults to zero
var crystals_desired: int = 100 # assigned externally by Crystals script
var greyscale: ColorRect # assigned externally by GreyscaleColorFilter script

func fill_crystal() -> void:
	crystals_filled += 1
	if crystals_filled == crystals_desired:
		greyscale.material.set_shader_parameter("saturation", 1.0)
		greyscale.material.set_shader_parameter("brightness", 1.0)

func regray() -> void:
	greyscale.material.set_shader_parameter("saturation", 0.0)
	greyscale.material.set_shader_parameter("brightness", 0.29)
