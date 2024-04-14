extends HSlider

func _ready() -> void:
    AudioServer.set_bus_volume_db(0, value)

func _value_changed(new_value: float) -> void:
    AudioServer.set_bus_volume_db(0, new_value)
