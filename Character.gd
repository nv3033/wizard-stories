extends CharacterBody2D
var speed = 300
var health = 100
var damage = 10
var striking = false
var blocking = false

@onready var _animated_sprite = $AnimatedSprite2D
@onready var _animation_player = $AnimationPlayer
@onready var _sword_animation_player = get_node("/root/test scene/player/AnimatedSprite2D/Sword/AnimationPlayer") 

func get_input():
    var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    velocity = input_dir * speed

func facing():
    if Input.is_action_pressed("ui_left"):
        _animated_sprite.scale.x = 1
    elif Input.is_action_pressed("ui_right"):
        _animated_sprite.scale.x = -1

func animate():
    get_input()
    if velocity.x == 0 and velocity.y == 0:
        _animated_sprite.play("default")
    else:
        _animated_sprite.play("moving")

func block():
    if Input.is_action_just_pressed("ui_select") && !striking:
        _sword_animation_player.play("block")
        blocking = true
        print("player >> block")
    if Input.is_action_just_released("ui_select"):
        _sword_animation_player.stop()
        blocking = false

func strike():
    if Input.is_action_just_pressed("ui_focus_next"):
        _sword_animation_player.play("strike")
        striking = true
        print("player >> strike")
        await get_tree().create_timer(0.25).timeout
        striking = false
        _sword_animation_player.stop()

func _physics_process(delta):
    var closest_enemy = null
    var closest_distance = 10000
    var enemies = []
    
    for enemy in get_tree().get_nodes_in_group("enemies"):
        enemies.append(enemy)

    for enemy in enemies:
        var distance = enemy.global_position.distance_to(global_position)
        if distance < closest_distance:
            closest_enemy = enemy
            closest_distance = distance
    
    if closest_enemy != null and position.distance_to(closest_enemy.position) <= 50 and striking:
            closest_enemy.take_damage(damage)
            striking = false

    get_input()
    facing()
    animate()
    block()
    strike()
    var collision = move_and_collide(velocity * delta)
    if collision:
        _animated_sprite.stop()
        _animated_sprite.play("default")

func take_damage(damage):
    health -= damage
    print("player(health) >> ", health)
    _animation_player.play("on_hit")
