extends Node

var player_information : Dictionary = {}
var players : Dictionary = {}
var selfPlayerNode

var connectionTimer
var timeVar = 0

signal _time_ss_set


func _process(_delta):
	pass

remote func refresh_game_players(data):
	print("[Network] A flush and refresh players data request was sent by server")
	players = data

# warning-ignore:unused_argument
remote func game_setup(current_game_state, match_info):
	print(current_game_state)
	match current_game_state:
		"lobby":
# warning-ignore:return_value_discarded
			get_tree().change_scene_to(preload("res://src/scenes/menu/lobby.tscn"))
		"game":
			pass
		"intermission":
			pass

func _time_ss_add():
	timeVar += 0.1
	emit_signal("_time_ss_set", timeVar)

func _connected_ok():
	print("[Network] Successfully connected to server. (Time: " + str(timeVar) + "s)")
	connectionTimer.stop()
	_register_player()

func _connection_failed():
	print("[Network] Could not connect to server. (Time: " + str(timeVar) + "s)")
	connectionTimer.stop()

func _server_disconnected():
	print("[Network] Lost connection of server.")

func _connect_to_server(ip : String, port : int):
	print("[Network] Connecting to " + ip + ":" + str(port))
	Clientserverswitcher.peer.create_client(ip, port)
	get_tree().network_peer = Clientserverswitcher.peer
	
	connectionTimer = Timer.new()
	connectionTimer.name = "ConnectionTimer"
	self.add_child(connectionTimer)
	connectionTimer.wait_time = 0.1
# warning-ignore:return_value_discarded
	connectionTimer.connect("timeout", self, "_time_ss_add")
# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_connected", self, "_player_connected")
# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
# warning-ignore:return_value_discarded
	get_tree().connect("connected_to_server", self, "_connected_ok")
# warning-ignore:return_value_discarded
	get_tree().connect("connection_failed", self, "_connection_failed")
# warning-ignore:return_value_discarded
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	connectionTimer.start(0.1)

func _register_player():
	print("[Network] Player registration request sent")
	Clientserverswitcher.rpc_id_some(1, "register_player", player_information)

	
func _disconnect_server():
	print("[Network] Connexion terminated")
	get_tree().network_peer = null
	return OK

func _player_connected(id):
	if id != 1 or id != get_tree().get_network_unique_id():
		if id != 1:
			#spawn_player(id).set_network_master(id)
			pass

func _player_disconnected(id):
	if id != 1 or id != get_tree().get_network_unique_id():
		if id == 1:
			return
		#delete_player(id)
