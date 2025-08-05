extends Control

@export var sliderArr: Array[Control]

func _on_quit_game_button_pressed() -> void:
	get_tree().quit()

func _incdec_slider(sliderIndex: int, increase: bool):
	if 0 <= sliderIndex and sliderIndex < sliderArr.size():
		var currSlider = sliderArr[sliderIndex]
		if increase:
			currSlider.value += currSlider.step
		else:
			currSlider.value -= currSlider.step
