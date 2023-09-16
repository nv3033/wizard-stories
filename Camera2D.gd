extends Camera2D
var player
var speed = 200
func _ready():
	player = get_tree().get_nodes_in_group("player")[0]
func _physics_process(delta):
	var velocity = (player.position - position).normalized() * speed
	#print(player.position - position)
	if abs(player.position.x - position.x) > 50 or abs(player.position.x - position.x) > 50:
		self.position += velocity * delta