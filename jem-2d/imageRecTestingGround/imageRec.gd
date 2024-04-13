class_name ImageScorer extends Node

var recPatternImage = Image.new()
var circlePatternImage = Image.new()
var triagPatternImage = Image.new()

var drawingImage = Image.new()

func _ready():
	recPatternImage.load("res://imageRecTestingGround/GameJamPatternRec.png")
	circlePatternImage.load("res://imageRecTestingGround/PatternCircle.png")
	triagPatternImage.load("res://imageRecTestingGround/PatternTriangle.png")
	
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
	print(score)
	return score


func scoreImage(img):
	print("E")
	var dict = {}
	print("Rectangle")
	dict["rectangle"] = compare(recPatternImage, img)
	print("Circle")
	dict["circle"] = compare(circlePatternImage, img)
	print("Triangle")
	dict["triangle"] = compare(triagPatternImage, img)
	print(dict)  