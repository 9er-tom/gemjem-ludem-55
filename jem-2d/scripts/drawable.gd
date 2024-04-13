extends Node2D

var lines : Array = [[]]

#var image : Image

@onready
var imgScorer: ImageScorer = $ImageScorer
@onready
var rect : ColorRect= $ColorRect
var limitRect: Rect2;

func _ready():
	limitRect = rect.get_rect()
	print(limitRect)


func _draw():
	for line in lines:
		if line.size() == 1:
			draw_circle(line[0], 3, Color.RED)
		if line.size() > 1:
			draw_polyline(line, Color.RED, 4, true)
	pass


func _process(_delta):
	if (Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		var mousePosition = get_viewport().get_mouse_position()

		if mousePosition.x > limitRect.position.x && mousePosition.x < limitRect.end.x && mousePosition.y > limitRect.position.y && mousePosition.y < limitRect.end.y: 
			print(limitRect.position, limitRect.end, mousePosition)
			print(rect.get_rect())


			if lines[-1].size() == 0 || lines[-1][-1] != mousePosition:
				lines[-1].append(mousePosition)
				queue_redraw()
	
	else:
		if lines[-1].size() != 0:
			lines.append([])


	if Input.is_action_just_pressed('ui_select'):
		save_picture()


func save_picture():
	# Wait until the frame has finished before getting the texture.
	await RenderingServer.frame_post_draw

	var img = createSymbolImage()

	img.save_png("F:\\Godot Projects\\LD\\gemjem-ludem-55-1\\jem-2d\\scripts\\test.png")
	imgScorer.scoreImage(img)


func createSymbolImage():
	var img = Image.create(limitRect.size.x, limitRect.size.y, false, 5)

	for line in lines:
		var prevPoint = null
		for point in line:
			if prevPoint:
				draw_line_on_img(img, prevPoint - limitRect.position, point - limitRect.position, Color.BLACK)
			else:
				img.set_pixel(point.x - limitRect.position.x, point.y - limitRect.position.y, Color.BLACK)
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
	while true:
		img.set_pixel(x0, y0, color)  # Function to set the pixel (to be implemented)
		draw_circle_on_img(img, x0, y0, 3, color)
		if x0 == x1 and y0 == y1:
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
				if ix < 0 || iy < 0 || ix > img.get_width() || iy > img.get_height():
					continue
				img.set_pixel(ix, iy, color)