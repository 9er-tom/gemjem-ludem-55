class_name ResourceManagement extends TextureProgressBar


## Spend available resources, returns true if enough resources are available, otherwise false
func spend_resource(amount: float) -> bool:
    var newValue: float = value - amount
    if newValue >= 0:
        value = newValue
        return true
    else: return false
    
func gain_resource(amount: float):
    var newValue: float = value + amount
    value = max_value if newValue > max_value else newValue