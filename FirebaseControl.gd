extends Node

signal login_done(success: bool, payload)

const _email : String = "testaccount@godotnuts.test"
const _password : String = "Password1234"

var rooms: FirestoreCollection
var webapp : String = "https://secretcode-code.web.app?room="

var login_pending : bool = false

func _ready():
	# connect signals (use connect(signal_name, Callable) — two args)
	Firebase.Auth.connect("login_succeeded", Callable(self, "_on_FirebaseAuth_login_succeeded"))
	Firebase.Auth.connect("login_failed", Callable(self, "_on_login_failed"))

func login() -> String:
	# prevent double-invoking while a login is already pending
	if login_pending:
		return "" # or you could raise/return an error dict
	login_pending = true

	rooms = Firebase.Firestore.collection("rooms")

	# start login
	Firebase.Auth.login_with_email_and_password(_email, _password)

	# wait the login_done signal (it will be emitted by handlers)
	var result : Array = await self.login_done
	var success : bool = false
	var payload = null
	if result.size() >= 2:
		success = bool(result[0])
		payload = result[1]

	# reset guard just in case (handlers already set it, but keep safe)
	login_pending = false

	if success:
		return payload as String
	else:
		return ""

# Called by Firebase when auth succeeds
func _on_FirebaseAuth_login_succeeded(_auth) -> void:
	print_debug("Login succeeded, creating room...")
	_create_qr_async()

# Called by Firebase when auth fails
func _on_login_failed(error_code, message) -> void:
	print_debug("Firebase login failed: %s - %s" % [str(error_code), str(message)])
	# tell callers the login failed
	login_pending = false
	emit_signal("login_done", false, {"code": error_code, "message": message})
	# (optional) disconnect the connected signal handlers so next login starts fresh
	# Note: disconnect may fail if not connected; wrap in `if` if desired.

# Async helper that creates the room and emits the final signal
func _create_qr_async() -> void:
	var document = await rooms.add("", {"words": []})
	if document == null:
		print_debug("rooms.add returned null — creating document failed.")
		login_pending = false
		emit_signal("login_done", false, {"code": "add_failed", "message": "rooms.add returned null"})
		return

	Global.doc_name = document.doc_name
	var url : String = webapp + Global.doc_name
	print_debug("Room created: %s" % url)
	login_pending = false
	emit_signal("login_done", true, url)
