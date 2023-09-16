extends CharacterBody2D

# Свойства врага
var speed = 50
var damage = 10
var health = 20

var player
var anim_sprite # Анимационный плеер
var anim_player
var is_attacking = false # Флаг для проверки стадии атаки
var previous_distance_to_player = 0


func _ready():
	player = get_node("/root/test scene/player") # Получаем ссылку на игрока
	anim_sprite = $AnimatedSprite2D
	anim_player = $AnimationPlayer

func _physics_process(delta):
	var velocity = (player.position - position).normalized() * speed

	var distance_to_player = position.distance_to(player.position)
	if distance_to_player < 50:
		if previous_distance_to_player > 50:
			attack(player)
	else:
		move_and_collide(velocity * delta)
	
	previous_distance_to_player = distance_to_player

	if velocity.x == 0 and velocity.y == 0:
		anim_sprite.play("default")
	else:
		anim_sprite.play("walking")

	if velocity.x >= 0:
		anim_sprite.flip_h = true
	else:
		anim_sprite.flip_h = false

	if health <= 0:
		queue_free() 

func attack(player):
	await get_tree().create_timer(1).timeout
	if !Input.is_action_pressed("ui_select"):
		print("enemy >> strike")
		player.take_damage(damage)


func take_damage(damage):
	health -= damage
	print("enemy(health) >> ", health)
	anim_player.play("on_hit")
