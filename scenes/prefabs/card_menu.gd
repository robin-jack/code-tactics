extends PopupPanel

@onready var line = $LineEdit
@onready var hbox = $HBoxContainer

signal replace(card: Card)
signal edit(card: Card, new_word: String)

var selected_card: Node = null

func setup_for(card: Node) -> void:
	selected_card = card

func _on_replace_button_up():
	print_debug("removetoto")
	replace.emit(selected_card)

func _on_edit_button_up():
	print_debug("editoroto")
	line.show()
	hbox.hide()

func _on_popup_hide():
	line.hide()
	hbox.show()

func _on_line_edit_text_submitted(new_word: String):
	edit.emit(selected_card, new_word)
	line.clear()
