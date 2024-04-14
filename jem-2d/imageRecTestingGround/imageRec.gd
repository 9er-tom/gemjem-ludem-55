class_name ImageScorer extends Node

signal drawn_sigil
signal drawn_sigil_percent

var recPatternImage = Image.new()
var circlePatternImage = Image.new()
var triagPatternImage = Image.new()

var pFire = Image.new()
var pHoly = Image.new()
var pLife = Image.new()
var pNecro = Image.new()
var pWater = Image.new()


var drawingImage = Image.new()
 
func _ready():
	#recPatternImage.load("res://imageRecTestingGround/GameJamPatternRec.png")
	#circlePatternImage.load("res://imageRecTestingGround/PatternCircle.png")
	#triagPatternImage.load("res://imageRecTestingGround/PatternTriangle.png")

	pFire = load("res://imageRecTestingGround/Patterns/pFire.png").get_image()
	pHoly = load("res://imageRecTestingGround/Patterns/pHoly.png").get_image()
	pLife = load("res://imageRecTestingGround/Patterns/pLife.png").get_image()
	pNecro = load("res://imageRecTestingGround/Patterns/pNecro.png").get_image()
	pWater = load("res://imageRecTestingGround/Patterns/pWater.png").get_image()


	#drawingImage.load("res://imageRecTestingGround/BadRecDrawing.png")
	
	#scoreImage(drawingImage)
	
func sort_function(a, b):
	return a < b  # Sorting by value


func compare(pattern, drawing, maxPoints):
	pattern.resize(50, 50)
	drawing.resize(50, 50)
	var score = 0
	for x in range(50):
		for y in range(50):
			var patternPixelColor = pattern.get_pixel(x, y)
			var drawingPixelColor = drawing.get_pixel(x, y)
			#print(drawingPixelColor)
			score = score + (patternPixelColor.a * drawingPixelColor.a) - ((1 - patternPixelColor.a) * (drawingPixelColor.a / 2))
	
	# print(pattern, " ", score , "/", maxPoints)
	return (clamp(score, 0, maxPoints)/maxPoints) * 100


func scoreImage(img):
	var dict = {}
	
	dict[ElementalAffinityComponent.ElementType.FIRE] = compare(pFire, img, 135)
	dict[ElementalAffinityComponent.ElementType.HOLY] = compare(pHoly, img, 120)
	dict[ElementalAffinityComponent.ElementType.LIFE] = compare(pLife, img, 210)
	dict[ElementalAffinityComponent.ElementType.NECRO] = compare(pNecro, img, 170)
	dict[ElementalAffinityComponent.ElementType.WATER] = compare(pWater, img, 180)
	
	#get Results
	var maxKey = get_key_of_largest_value(dict)
	print("Score dict: ", dict)
	if maxKey != null:
		# print(maxKey, " ", dict[maxKey])
		drawn_sigil.emit(maxKey)
		drawn_sigil_percent.emit(dict[maxKey])


func get_key_of_largest_value(input_dict):
	var max_key = null
	var max_value = 40  # Minimal needed threshold

	for key in input_dict.keys():
		var value = input_dict[key]
		if value > max_value:
			max_value = value
			max_key = key

	return max_key
