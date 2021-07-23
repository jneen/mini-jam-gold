extends Node

var last_self_sent_message : String= ""

signal recieved_chat_message

func _ready():
	pass # Replace with function body.

func send_message(message : String):
	rpc("recieve_message", message)

remote func recieve_message(message : String):
	var author_id = get_tree().get_rpc_sender_id()
	emit_signal("recieved_chat_message", message, author_id)
