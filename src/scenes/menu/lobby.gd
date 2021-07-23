extends Control

var hovering = null
onready var join = $ButtonContainer/Join
onready var host = $ButtonContainer/Host
var timeVar : float = 0
onready var Client = Clientserverswitcher.networkNode
onready var Server = Clientserverswitcher.networkNode

func update_time(newVar):
	timeVar = newVar

func _ready():
# warning-ignore:return_value_discarded
	Chat.connect("recieved_chat_message", self, "chat_message")
	$LoadingInfo.hide()
	if get_tree().has_network_peer():
		
		$ButtonContainer.hide()
	else:
		$ButtonContainer.show()
	$KarmaLabel.show()
	if not get_tree().has_network_peer():
		$Lobby.hide()

func chat_message(message : String, author_id : int):
	print("Recieved a chat message:\n"+message+"\nSent by: " + str(author_id))
	append_message("[" + str(author_id) + "] : " + message)

func _process(_delta):
	match hovering:
		join:
			$KarmaLabel.text = "Join up to 8 friends!"
		host:
			$KarmaLabel.text = "Host a game and invite your friends to play!"
		null:
			$KarmaLabel.text = "What will you do today?"

func _on_Host_mouse_entered():
	hovering = host

func _on_Host_mouse_exited():
	hovering = null

func _on_Join_mouse_entered():
	hovering = join

func _on_Join_mouse_exited():
	hovering = null

func _on_Join_pressed():
	timeVar = 0
	if $ButtonContainer/NameTextBox.text != "" and $ButtonContainer/IPTextBox.text.is_valid_ip_address():
		Clientserverswitcher.switch("client")
		Client.connect("_time_ss_set", self, "update_time")
		Client._connect_to_server($ButtonContainer/IPTextBox.text, 6129)
		$LoadingInfo.text = "Connecting, spent " + str(timeVar) + "s connecting"
		$LoadingInfo.show()
		$ButtonContainer.hide()
		$KarmaLabel.hide()
	else:
		$GameAlert.dialog_text = "Please put a name AND a valid IP address."
		$GameAlert.popup()
	

func _on_Host_pressed():
	if $ButtonContainer/NameTextBox.text != "":
		$LoadingInfo.text = "Creating lobby..."
		$LoadingInfo.show()
		$ButtonContainer.hide()
		$KarmaLabel.hide()
		Clientserverswitcher.switch("server")
		Server._create_server(6129, 8)
		$Lobby.show()
		$LoadingInfo.hide()
	else:
		$GameAlert.dialog_text = "Please put a name."
		$GameAlert.popup()

func _on_Lobby_pressed():
# warning-ignore:return_value_discarded
	if get_tree().has_network_peer():
		if get_tree().is_network_server():
			Server._close_server()
		else:
			Client._disconnect_server()
	
	get_tree().change_scene_to(load("res://src/scenes/menu/menu.tscn"))

func append_message(message : String):
	$Lobby/ChatBox/Chat.bbcode_text = $Lobby/ChatBox/Chat.bbcode_text + "\n" + message
	print($Lobby/ChatBox/Chat.bbcode_text)

func _on_SendMessage_pressed():
	Chat.send_message($Lobby/SendTextbox.text)
	append_message("[You] : " + $Lobby/SendTextbox.text)
	$Lobby/SendTextbox.text = ""


func _on_SendTextbox_text_entered(_new_text):
	Chat.send_message($Lobby/SendTextbox.text)
	append_message("[You] : " + $Lobby/SendTextbox.text)
	$Lobby/SendTextbox.text = ""
