extends Node2D

var pFire = Image.new()
var pHoly = Image.new()
var pLife = Image.new()
var pNecro = Image.new()
var pWater = Image.new()


@onready var imgScorer: ImageScorer = $ImageScorer
@onready var rect : ColorRect = $ColorRect
@onready var timerComponent: Timer = $Timer
@export var lastDrawnSymbol: PackedScene

var limitRect: Rect2;
var lines : Array = [[]]
var prevSymbols : Array = [[[]]]

var tex = ImageTexture.new()

func _ready():
	pFire = load("res://imageRecTestingGround/Patterns/pFire.png").get_image()
	pHoly = load("res://imageRecTestingGround/Patterns/pHoly.png").get_image()
	pLife = load("res://imageRecTestingGround/Patterns/pLife.png").get_image()
	pNecro = load("res://imageRecTestingGround/Patterns/pNecro.png").get_image()
	pWater = load("res://imageRecTestingGround/Patterns/pWater.png").get_image()

	timerComponent.timeout.connect(activateSymbol)
	limitRect = rect.get_rect()
	print(limitRect)

func _draw():
	for i in range(prevSymbols.size()):
		for line in prevSymbols[i]:
			if line.size() == 1:
				draw_circle(line[0], 2, Color(0,0,0,0.2-i*0.02))
			if line.size() > 1:
				draw_polyline(line, Color(0,0,0,0.2-i*0.02), 2, true)

	for line in lines:
		if line.size() == 1:
			draw_circle(line[0], 1, Color(1,0.2,0.2,0.3))
		if line.size() > 1:
			draw_polyline(line, Color(1,0.2,0.2,0.3), 1, true)

func _process(_delta):
	if (Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		timerComponent.start()

		if not $AudioStreamPlayer.is_playing():
			$AudioStreamPlayer.play()

		var mousePosition = get_viewport().get_mouse_position()
		if mousePosition.x > limitRect.position.x && mousePosition.x < limitRect.end.x && mousePosition.y > limitRect.position.y && mousePosition.y < limitRect.end.y: 

			if lines[-1].size() == 0 || checkDist(lines[-1][-1], mousePosition):
				lines[-1].append(mousePosition)
				queue_redraw()
	
	else:
		$AudioStreamPlayer.stop()
		if lines[-1].size() != 0:
			lines.append([])

	if Input.is_action_just_pressed("Number1"):
		createEffect(pFire, 0.95)
	if Input.is_action_just_pressed("Number2"):
		createEffect(pHoly, 0.95)
	if Input.is_action_just_pressed("Number3"):
		createEffect(pNecro, 0.95)
	if Input.is_action_just_pressed("Number4"):
		createEffect(pLife, 0.95)
	if Input.is_action_just_pressed("Number5"):
		createEffect(pWater, 0.95)


func checkDist(p1, p2):
	return false if abs(p1.x - p2.x) < 5 && abs(p1.y - p2.y) < 5 else true

func activateSymbol(): 
	if lines.size() > 0 && lines[0].size() > 0:
		save_picture(lines)
		prevSymbols.push_front(lines)
		if prevSymbols.size() > 10:
			prevSymbols.pop_back()
		lines = [[]]
		queue_redraw()


func save_picture(lastSymbol):
	var img = createSymbolImage(lastSymbol, Color.RED)

	createEffect(img)
	imgScorer.scoreImage(img)

func createEffect(img, scaler = 1.):
	tex = ImageTexture.create_from_image(img)
	var newObject = lastDrawnSymbol.instantiate()
	newObject.scale = Vector2(scaler, scaler)
	add_child(newObject)
	newObject.get_node("TextureRect").texture = tex
	newObject.position = limitRect.position


func createSymbolImage(lastSymbol, color = Color.BLACK):
	var img = Image.create(limitRect.size.x, limitRect.size.y, false, 5)

	for line in lastSymbol:
		var prevPoint = null
		for point in line:
			if prevPoint:
				draw_line_on_img(img, prevPoint - limitRect.position, point - limitRect.position, color)
			else:
				draw_circle_on_img(img, point.x - limitRect.position.x, point.y - limitRect.position.y, 7, color)
			prevPoint = point
		
	return img

func draw_line_on_img(img, p0, p1, color):
	var x0 = p0.x
	var y0 = p0.y
	var x1 = p1.x
	var y1 = p1.y

	var dx = abs(x1 - x0)
	var sx = -1 if x0 > x1 else 1
	var dy = -abs(y1 - y0)
	var sy = -1 if y0 > y1 else 1
	var err = dx + dy  # error value e_xy

	var i = 0
	while true:
		if i % 3 == 0:
			draw_circle_on_img(img, x0, y0, 5, color)
		i += 1
		if (x0 == x1 and y0 == y1) or i > 10:
			break
		var e2 = 2 * err
		if e2 >= dy:  # e_xy + e_x > 0
			err += dy
			x0 += sx
		if e2 <= dx:  # e_xy + e_y < 0
			err += dx
			y0 += sy

func draw_circle_on_img(img, x, y, radius, color):
	for ix in range(x - radius, x + radius + 1):
		for iy in range(y - radius, y + radius + 1):
			if (ix - x) * (ix - x) + (iy - y) * (iy - y) <= radius * radius:
				if ix < 0 || iy < 0 || ix >= img.get_width() || iy >= img.get_height():
					continue
				img.set_pixel(ix, iy, color)
