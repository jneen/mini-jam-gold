extends Node


var peer = NetworkedMultiplayerENet.new()
onready var networkNode

func _ready():
	networkNode = Node.new()
	
	get_tree().get_root().call_deferred("add_child", networkNode)

func switch(to):
	if to == "server":
		networkNode.name = "Server"
		networkNode.set_script(preload("res://src/server/server.gd"))
	elif to == "client":
		networkNode.name = "Client"
		networkNode.set_script(preload("res://src/server/client.gd"))

func rpc_id_some(a,b,c):
	rpc_id(a, b, c)
