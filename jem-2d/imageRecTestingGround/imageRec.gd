class_name ImageScorer extends Node

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

	pFire.load("res://imageRecTestingGround/Patterns/pFire.png")
	pHoly.load("res://imageRecTestingGround/Patterns/pHoly.png")
	pLife.load("res://imageRecTestingGround/Patterns/pLife.png")
	pNecro.load("res://imageRecTestingGround/Patterns/pNecro.png")
	pWater.load("res://imageRecTestingGround/Patterns/pWater.png")


	#drawingImage.load("res://imageRecTestingGround/BadRecDrawing.png")
	
	#scoreImage(drawingImage)
	
func sort_function(a, b):
	return a < b  # Sorting by value


func compare(pattern, drawing):
	pattern.resize(50, 50)
	drawing.resize(50, 50)
	var score = 0
	for x in range(50):
		for y in range(50):
			var patternPixelColor = pattern.get_pixel(x, y)
			var drawingPixelColor = drawing.get_pixel(x, y)
			#print(drawingPixelColor)
			score = score + (patternPixelColor.a * drawingPixelColor.a)
	return score


func scoreImage(img):
	var dict = {}

	dict["fire"] = compare(pFire, img)
	dict["holy"] = compare(pHoly, img)
	dict["life"] = compare(pLife, img)
	dict["necro"] = compare(pNecro, img)
	dict["water"] = compare(pWater, img)
	
	#get Results
	var maxKey = get_key_of_largest_value(dict)
	if maxKey:
		print(maxKey, " ", dict[maxKey])


func get_key_of_largest_value(input_dict):
	var max_key = null
	var max_value = 100  # Minimal needed threshold

	for key in input_dict.keys():
		var value = input_dict[key]
		if value > max_value:
			max_value = value
			max_key = key

	return max_key