extends CharacterBody2D

# Свойства врага
var speed = 100
var damage = 10

var player
var anim_player # Анимационный плеер
var is_attacking = false # Флаг для проверки стадии атаки


func _ready():
	player = get_node("/root/test scene/CharacterBody2D") # Получаем ссылку на игрока
	anim_player = $AnimatedSprite2D

func _physics_process(delta):
	print(player.position)
	
	# Вычисляем направление и двигаемся к игроку
	var velocity = (player.position - position).normalized() * speed
	move_and_collide(velocity * delta)

	# Поворачиваем спрайт врага в направлении игрока
	if velocity.x != 0:
		$AnimatedSprite2D.scale.x = velocity.x.sign()

	# Проверяем дистанцию до игрока и атакуем при достаточной близости
	var distance_to_player = position.distance_to(player.position)
	if distance_to_player < 50:
		attack()
	
	if velocity.x == 0 and velocity.y == 0:
		anim_player.play("default")
	else:
		anim_player.play("moving")

func attack():
	print("attack")

