extends Node

signal login_done(success: bool)

const _email : String = "testaccount@godotnuts.test"
const _password : String = "Password1234"

var auth: Dictionary
var rooms: FirestoreCollection
var webapp : String = "https://secretcode-code.web.app?room="
var doc_name: String

func _ready():
	Firebase.Auth.login_succeeded.connect(_on_login_succeeded)
	Firebase.Auth.login_failed.connect(_on_login_failed)
	rooms = Firebase.Firestore.collection("rooms")

func login():
	#already logged in
	if not auth.is_empty():
		login_done.emit(true)

	# start login
	Firebase.Auth.login_with_email_and_password(_email, _password)

func _on_login_succeeded(_auth) -> void:
	print_debug("Login succeeded!")
	login_done.emit(true)
	auth = _auth

func _on_login_failed(error_code, message) -> void:
	print_debug("Firebase login failed: %s - %s" % [str(error_code), str(message)])
	login_done.emit(false)
	auth = {}

func create_qr_async() -> String:
	# not logged in
	#if auth != null:
		#login_done.emit(false)

	var document = await rooms.add("", {"words": []})
	# if failed
	if document == null:
		print_debug("Creating room failed.")
		return "error"
	# success
	doc_name = document.doc_name
	var url : String = webapp + doc_name
	print_debug("Room created: %s" % url)
	return url
