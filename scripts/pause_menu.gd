extends Control

@export var sliderArr: Array[HSlider]
@export var scalableControls: Array[Control]
@export var scalableWindow: ConfirmationDialog

var uiUtil = preload('res://scripts/ui_util.gd').new()

const MUSIC_SLIDER_INDEX = 0
const SOUND_EFFECTS_SLIDER_INDEX = 1
const UI_SCALE_SLIDER_INDEX = 2

const MIN_UI_SCALE = 0.2

@onready var tree = get_tree()
@onready var root = tree.get_root()

func _ready() -> void:
	_refresh_ui_scale()
	_connect_tooltip_signals()

func _get_control_children_recursive_array(parentNode: Control) -> Array[Control]:
	var result: Array[Control] = []
	if parentNode.get_child_count() != 0:
		var children = parentNode.get_children()
		var controlChildren = []
		for currChild in children:
			if currChild is Control:
				controlChildren.append(currChild)
		result.append_array(controlChildren)
		for currChild in controlChildren:
			result.append_array(_get_control_children_recursive_array(currChild))
	return result

func _connect_tooltip_signals() -> void:
	var childrenRecursiveArr = _get_control_children_recursive_array(self)
	for currChild in childrenRecursiveArr:
		if currChild.tooltip_text != '':
			currChild.connect('child_entered_tree', try_tooltip_resize)

func _incdec_slider(sliderIndex: int, increase: bool) -> void:
	if 0 <= sliderIndex and sliderIndex < sliderArr.size():
		var currSlider = sliderArr[sliderIndex]
		if increase:
			currSlider.value += currSlider.step
		else:
			currSlider.value -= currSlider.step
		if sliderIndex == UI_SCALE_SLIDER_INDEX:
			_refresh_ui_scale()

func _get_ui_scale_value() -> float:
	var uiScaleSlider = sliderArr[UI_SCALE_SLIDER_INDEX]
	return MIN_UI_SCALE + (1.0 - MIN_UI_SCALE)*(uiScaleSlider.value / uiScaleSlider.max_value)

func _refresh_ui_scale() -> void:
	var scaleValue = _get_ui_scale_value()
	for currControl in scalableControls:
		currControl.scale = Vector2(scaleValue, scaleValue)
	scalableWindow.set_content_scale_factor(scaleValue)

func _input(event: InputEvent) -> void:
	var focusOwner = root.gui_get_focus_owner()
	if is_instance_valid(focusOwner) and focusOwner.name == 'UiScaleHSlider' \
	and (uiUtil._check_was_ui_movement_input(event) or uiUtil._check_was_left_mouse_click(event)):
		_refresh_ui_scale()

func try_tooltip_resize(node: Node) -> void:
	if node is PopupPanel:
		var scaleValue: float = _get_ui_scale_value()
		var children = node.get_children(true)
		for currChild in children:
			currChild.scale = Vector2(scaleValue, scaleValue)

func quit_game() -> void:
	tree.quit()
