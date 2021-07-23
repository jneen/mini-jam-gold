extends Node

var peer = NetworkedMultiplayerENet.new()
var current_game_state : String = "lobby"

onready var currentGameNode #= get_tree().get_root().get_node("Game")
onready var playerNodeResource #= preload("res://scenes/player/Player.tscn")

var players = {}
var match_info = {"" : ""}

func get_player_name_by_id(id):
	if players.has(id):
		return players[id]["name"]
	else:
		return null

func _create_server(port : int, max_players : int):
# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_connected", self, "_player_connected")
# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	print("[Server] Server started")
	print(Clientserverswitcher.peer.create_server(port, max_players))
	get_tree().network_peer = Clientserverswitcher.peer
	return OK

func _close_server():
	print("[Server] Server closed")
	get_tree().network_peer = null
# warning-ignore:return_value_discarded
	get_tree().disconnect("network_peer_connected", self, "_player_connected")
# warning-ignore:return_value_discarded
	get_tree().disconnect("network_peer_disconnected", self, "_player_disconnected")

	return OK

func _player_connected(id : int):
	print("[Server] Player ID " + str(id) + " connected, waiting for info registration")


func _player_disconnected(id : int):
	print("[Server] Player " + players[id]["name"] + " (ID: " + str(id) + ") disconnected")
	if players.has(id):
		players.erase(id)
	rpc("refresh_game_players", players)
	delete_player(id)

func _kick_player(id : int, reason : String):
	print("[Server] Player " + players[id]["name"] + " (ID: " +str(id) +") has been kicked for reason:\n[Server] " + reason)
	rpc_id(id, "kicked", "You have been kicked from the server.\n\n" + reason)
	peer.disconnect_peer(id, false)

puppet func register_player(info):
	var id = get_tree().get_rpc_sender_id()
	var canRegister = true
	if get_tree().get_network_connected_peers().size() > 1:
		for playerData in players.values():
			if playerData["name"] == info["name"]:
				canRegister = false
	
	if canRegister:
		print("[Server] Player " + info["name"] + " (ID: " + str(id) + ") registered successfully")
		
		players[id] = info
		rpc("refresh_game_players", players)
		yield(get_tree().create_timer(1.0), "timeout")
		spawn_player(id).set_network_master(id)
		rpc_id(id, "setup_game", current_game_state, match_info)
	else:
		print("[Server] Kicked player for trying to register with someone already having his name")
		_kick_player(id, "A player already have this name, please try with another one")

func delete_player_registery(id):
	players.erase(id)

func delete_player(id):
	currentGameNode.get_node("Players").get_node(str(id)).queue_free()

func spawn_player(id):
	var playerName = str(id)
	var playerNode = playerNodeResource.instance()
	playerNode.name = playerName
	
	currentGameNode.get_node("Players").call_deferred("add_child", playerNode)
	
	return playerNode
