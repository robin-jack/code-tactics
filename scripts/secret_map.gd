extends GridContainer

@export var sub_viewport: Node

## Creates a board with squares of color TYPE instead of CARD,
## and returns an URL pointing to an Image of this board.
func create_secret_grid() -> String:
	var sm = MapManager.secret_map
	print_debug("Adding cards to SECRET GRID")
	columns = Settings.game.col
	_clear()
	for i in Settings.game.num_cards:
		var sq := ColorRect.new()
		var color = Global.COLOR[sm.values()[i]]
		sq.color = color
		sq.size_flags_horizontal = Control.SIZE_FILL | Control.SIZE_EXPAND
		sq.size_flags_vertical = Control.SIZE_FILL | Control.SIZE_EXPAND
		add_child(sq)
	return await _create_secret_image()

func _clear():
	for child in get_children():
		remove_child(child)
		child.queue_free()

func _create_secret_image() -> String:
	print_debug("Creating + uploading image and creating QR...")
	await RenderingServer.frame_post_draw
	await get_tree().process_frame
	var img = sub_viewport.get_texture().get_image().save_png_to_buffer()
	var _info = await Firebase.Storage.ref("Firebasetester/upload/test.png").put_data(img)
	var url = await Firebase.Storage.ref("Firebasetester/upload/test.png").get_download_url()
	print("url: ", url)
	return url
