extends CharacterBody2D
var speed = 300

@onready var _animated_sprite = $AnimatedSprite2D

func get_input():
    var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    velocity = input_dir * speed

func facing():
    if Input.is_action_pressed("ui_left"):
        _animated_sprite.flip_h = false
    elif Input.is_action_pressed("ui_right"):
        _animated_sprite.flip_h = true

func animate():
    get_input()
    if velocity.x == 0 and velocity.y == 0:
        _animated_sprite.play("default")
    else:
        _animated_sprite.play("moving")


func _physics_process(delta):
    get_input()
    facing()
    animate()
    var collision = move_and_collide(velocity * delta)
    if collision:
        _animated_sprite.stop()
        _animated_sprite.play("default")
