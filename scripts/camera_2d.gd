extends Camera2D

var player: Node

func _ready() -> void:
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		player = players[0]
	else:
		push_error("player not found")

func _physics_process(_delta: float) -> void:
	self.position = player.position
