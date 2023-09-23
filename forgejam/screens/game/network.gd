extends Node



const DEFAULT_PORT = 5000
const MAX_PEERS = 2


var player_name = 'server'
var players = {}
var last_transform


func _ready():
	get_tree().connect("network_peer_connected", self, "player_connected")
	get_tree().connect("network_peer_disconnected", self, "player_disconnected")
	host_game()


remote func register_player(player_name):
	var sender = get_tree().get_rpc_sender_id()
	players[sender] = player_name


func player_connected(id):
	print("Player: " + str(id) + " connected")

func player_disconnected(id):
	print("Player: " + str(id) + " disconnected")
	remove_player(id)
	players.erase(id)


func remove_player(id):
	var root = get_tree().get_root()
	print("player: " + str(id) + " left the game")


func host_game():
	var host = NetworkedMultiplayerENet.new()
	host.create_server(DEFAULT_PORT, MAX_PEERS)
	get_tree().set_network_peer(host)

func display_info():
	print("Server running...\n")
	for ip in IP.get_local_addresses():
		if str(ip).split(".")[0] == "192":
			print("Server ip: " + ip)
	print("Server port: " + str(DEFAULT_PORT))
	print("Server max players: " + str(MAX_PEERS))
