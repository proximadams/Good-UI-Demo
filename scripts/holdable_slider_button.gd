extends Button

const REFIRE_WAIT_TIME: float = 0.5
const REFIRE_STEP_TIME: float = 0.05

@export var slider: HSlider
@export var sliderCannotChangeSound: AudioStreamPlayer

var heldTimer: float = 0.0
var heldCount: int = 0
var playedCannotChangeSound: bool = false

@onready var increase: bool = _check_is_button_more()

func _ready() -> void:
	self.connect('button_down', _on_button_down)
	self.connect('button_up', _on_button_up)

func _process(delta: float) -> void:
	if 0.0 < heldTimer:
		var oldHeldTimer = heldTimer
		var nextWaitTime = REFIRE_WAIT_TIME + (heldCount * REFIRE_STEP_TIME)
		heldTimer += delta
		if oldHeldTimer < nextWaitTime and nextWaitTime <= heldTimer:
			heldCount += 1
			if not playedCannotChangeSound and ((slider.value == slider.min_value and not increase) \
			or (slider.value == slider.max_value and increase)):
				playedCannotChangeSound = true
				sliderCannotChangeSound.play()
			if increase:
				slider.value += slider.step
			else:
				slider.value -= slider.step

func _on_button_down():
	heldTimer = 0.00001

func _on_button_up():
	heldTimer = 0.0
	heldCount = 0
	playedCannotChangeSound = false

func _check_is_button_more():
	return 'More' in self.name
