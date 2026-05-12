extends CharacterBody2D
const SPEED = 45.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $Hitbox

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()

func take_damage():
	anim.play("dead")
	hitbox.queue_free()
