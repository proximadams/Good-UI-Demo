extends Object

func _check_is_movement_input(event: InputEvent):
	return event.is_action('ui_left') or event.is_action('ui_right') or event.is_action('ui_up') or event.is_action('ui_down')

func _check_was_ui_movement_input(event: InputEvent):
	return (event is InputEventKey or event is InputEventJoypadButton) and not event.pressed and _check_is_movement_input(event)

func _check_was_left_mouse_click(event: InputEvent):
	return event is InputEventMouseButton and not event.pressed and event.button_index == MOUSE_BUTTON_LEFT
