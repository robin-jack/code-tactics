extends GridContainer

@export var sub_viewport: Node

func create_secret_grid():
	print_debug("Adding cards to SECRET GRID")
	columns = Global.columns
	_clear()
	for i in Global.num_cards:
		var sq := ColorRect.new()
		var color = Global.COLOR[Global.map.values()[i]]
		sq.color = color
		sq.size_flags_horizontal = Control.SIZE_FILL | Control.SIZE_EXPAND
		sq.size_flags_vertical = Control.SIZE_FILL | Control.SIZE_EXPAND
		add_child(sq)

func _clear():
	for child in get_children():
		remove_child(child)
		child.queue_free()

func create_secret_image():
	print_debug("Creating + uploading image and creating QR...")
	await RenderingServer.frame_post_draw
	await get_tree().process_frame
	var img = sub_viewport.get_texture().get_image().save_png_to_buffer()
	await Firebase.Storage.ref("Firebasetester/upload/test.png").put_data(img)
	var url = await Firebase.Storage.ref("Firebasetester/upload/test.png").get_download_url()
	print_debug(url)
	return url
