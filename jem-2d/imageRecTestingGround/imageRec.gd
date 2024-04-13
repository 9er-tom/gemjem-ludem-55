extends Node

func _ready():
	var recPatternImage = Image.new()
	recPatternImage.load("res://imageRecTestingGround/GameJamPatternRec.png")
	var circlePatternImage = Image.new()
	circlePatternImage.load("res://imageRecTestingGround/PatternCircle.png")
	var triagPatternImage = Image.new()
	triagPatternImage.load("res://imageRecTestingGround/PatternTriangle.png")
	
	var drawingImage = Image.new()
	drawingImage.load("res://imageRecTestingGround/BadRecDrawing.png")
	
	var dict = {}
	print("Rectangle")
	dict["rectangle"] = compare(recPatternImage, drawingImage)
	print("Circle")
	dict["circle"] = compare(circlePatternImage, drawingImage)
	print("Triangle")
	dict["triangle"] = compare(triagPatternImage, drawingImage)
	

	print(dict)  
	
func sort_function(a, b):
	return a < b  # Sorting by value


func compare(patternImage, drawingImage):
	patternImage.resize(50, 50)
	drawingImage.resize(50, 50)
	var score = 0
	for x in range(50):
		for y in range(50):
			var patternPixelColor = patternImage.get_pixel(x, y)
			var drawingPixelColor = drawingImage.get_pixel(x, y)
			score = score + (patternPixelColor.a * drawingPixelColor.a)
	print(score)
	return score
