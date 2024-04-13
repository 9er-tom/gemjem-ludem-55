extends Panel

var lines : Array = [[]]
#

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

		if lines[-1].size() == 0 || lines[-1][-1] != mousePosition:
			lines[-1].append(mousePosition)
			queue_redraw()
	
	else:
		if lines[-1].size() != 0:
			lines.append([])


	if Input.is_action_just_pressed('ui_select'):
		print("iousdfgscdjfgvsdfhgf")
		save_picture()


func save_picture():
	# Wait until the frame has finished before getting the texture.
	await RenderingServer.frame_post_draw

	# Get the viewport image.
	var img = get_viewport().get_texture().get_image()
	print(img)
	# Crop the image so we only have canvas area.
	#var cropped_image = img.get_rect(Rect2(TL_node.global_position, IMAGE_SIZE))
	# Flip the image on the Y-axis (it's flipped upside down by default).
	#img.flip_y()

	#print(img)