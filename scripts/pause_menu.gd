extends Control

@export var sliderArr: Array[Control]

const MUSIC_SLIDER_INDEX = 0
const SOUND_EFFECTS_SLIDER_INDEX = 1
const UI_SCALE_SLIDER_INDEX = 2

const MIN_UI_SCALE = 0.2

@onready var tree = get_tree()
@onready var root = tree.get_root()
@onready var scalableControls = [$LabelPaused, $ButtonClose, $CentreControls]

func _ready() -> void:
	_refresh_ui_scale()

func _on_quit_game_button_pressed() -> void:
	tree.quit()

func _incdec_slider(sliderIndex: int, increase: bool):
	if 0 <= sliderIndex and sliderIndex < sliderArr.size():
		var currSlider = sliderArr[sliderIndex]
		if increase:
			currSlider.value += currSlider.step
		else:
			currSlider.value -= currSlider.step
		if sliderIndex == UI_SCALE_SLIDER_INDEX:
			_refresh_ui_scale()

func _refresh_ui_scale():
	var uiScaleSlider = sliderArr[UI_SCALE_SLIDER_INDEX]
	var scaleValue = MIN_UI_SCALE + (1.0 - MIN_UI_SCALE)*(uiScaleSlider.value / uiScaleSlider.max_value)
	for currControl in scalableControls:
		currControl.scale = Vector2(scaleValue, scaleValue)

func _input(event: InputEvent) -> void:
	var focusOwner = root.gui_get_focus_owner()
	if is_instance_valid(focusOwner) and focusOwner.name == 'UiScaleHSlider' \
	and (_check_was_ui_movement_input(event) or _check_was_left_mouse_click(event)):
		_refresh_ui_scale()

# Utility functions TODO move to it's own file
func _check_is_movement_input(event: InputEvent):
	return event.is_action('ui_left') or event.is_action('ui_right') or event.is_action('ui_up') or event.is_action('ui_down')

func _check_was_ui_movement_input(event: InputEvent):
	return (event is InputEventKey or event is InputEventJoypadButton) and not event.pressed and _check_is_movement_input(event)

func _check_was_left_mouse_click(event: InputEvent):
	return event is InputEventMouseButton and not event.pressed and event.button_index == MOUSE_BUTTON_LEFT
