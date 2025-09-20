extends Control

signal reload
signal to_playing

@onready var qr_button = $VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/QR
@onready var qr = $QRCodeRect

const _email : String = 'testaccount@godotnuts.test'
const _password : String = 'Password1234'

var rooms: FirestoreCollection
var webapp = "https://secretcode-code.web.app?room="

func _ready():
	Global.current_menu = Global.MENU.SETUP
	Firebase.Auth.login_succeeded.connect(_on_FirebaseAuth_login_succeeded)
	Firebase.Auth.login_failed.connect(_on_login_failed)
	Firebase.Auth.login_with_email_and_password(_email, _password)
	rooms = Firebase.Firestore.collection('rooms')

# Function called when login to Firebase has completed successfully
func _on_FirebaseAuth_login_succeeded(_auth) -> void:
	print_debug("Login with email and password has worked")
	_create_qr()
	qr_button.disabled = false
	
# Function called when login to Firebase has failed
func _on_login_failed(error_code, message):
	print_debug("error code: " + str(error_code))
	print("message: " + str(message))

func _create_qr():
	var document = await rooms.add("", {'words':[]})
	Global.doc_name = document.doc_name
	var url = webapp + Global.doc_name 
	print_debug(url)
	qr.set_data(url)

func _on_qr_button_up():
	qr.visible = !qr.visible

func _on_reload_button_up():
	reload.emit()

func _on_to_playing_button_up():
	to_playing.emit()
