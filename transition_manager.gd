# transition_manager.gd
extends CanvasLayer

var shared_element: PanelContainer = null
var target_placeholder: PanelContainer = null

# MODIFIED: Now accepts a source and target path
func transition_with_shared_element(to_scene_path: String, source_node_path: NodePath, target_node_path: NodePath):
	var from_scene = get_tree().current_scene
	var node_to_share = from_scene.get_node_or_null(source_node_path)

	# We now assume the node is a Control, as per your use case.
	if not node_to_share is PanelContainer:
		push_error("Shared element must be a Control node.")
		get_tree().change_scene_to_file(to_scene_path) # Fallback
		return

	# --- 1. "Lift" the element ---
	var start_pos = node_to_share.global_position
	var start_size = node_to_share.size

	node_to_share.get_parent().remove_child(node_to_share)
	self.add_child(node_to_share)
	self.shared_element = node_to_share
	shared_element.global_position = start_pos # Re-apply after reparenting

	# --- 2. Load and add the new scene ---
	var next_scene_packed = load(to_scene_path)
	var to_scene = next_scene_packed.instantiate()
	# Add new scene behind the CanvasLayer, but keep the old one for a moment
	get_tree().root.add_child(to_scene)
	to_scene.move_to_front() # Ensure it's on top of the old scene

	# --- 3. Find the target using the new target_node_path ---
	target_placeholder = to_scene.get_node_or_null(target_node_path)
	if not target_placeholder is PanelContainer:
		push_error("Target placeholder node not found or not a Control in the new scene.")
		shared_element.queue_free()
		get_tree().change_scene_to_file(to_scene_path) # Fallback
		return

	target_placeholder.visible = false
	var end_pos = target_placeholder.global_position
	var end_size = target_placeholder.size
	
	# --- 4. Animate! ---
	# Hide the old scene and set the new one as current
	from_scene.visible = false
	get_tree().current_scene = to_scene

	var tween = create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_SINE) # Sine is very smooth for UI
	tween.set_ease(Tween.EASE_IN_OUT)

	# Animate the shared element's properties
	tween.tween_property(shared_element, "global_position", end_pos, 0.6)
	tween.tween_property(shared_element, "size", end_size, 0.6)

	# ✨ Extra Polish: Fade the new scene in
	to_scene.modulate = Color(1, 1, 1, 0) # Start transparent
	tween.tween_property(to_scene, "modulate", Color.WHITE, 0.4).from(Color(1, 1, 1, 0))

	await tween.finished

	# --- 5. "Drop" the element and clean up ---
	self.remove_child(shared_element)
	target_placeholder.get_parent().add_child(shared_element)
	
	# Make sure its name and position in the tree are correct
	shared_element.name = target_placeholder.name
	shared_element.set_position(target_placeholder.get_position())
	
	target_placeholder.queue_free()
	from_scene.queue_free()
	
	self.shared_element = null
