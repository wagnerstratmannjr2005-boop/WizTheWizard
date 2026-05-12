extends CharacterBody2D

enum OrcsState { WALK, ATTACK, DEAD }

const SPEED = 30.0
const GRAVITY = 980.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $Hitbox
@onready var wall_detector: RayCast2D = $WallDetector
@onready var ground_detector: RayCast2D = $GroundDetector
@onready var player_detector: RayCast2D = $PlayerDetector
@onready var attack_cooldown: Timer = $AttackCooldown

var state: OrcsState
var direction = 1
var can_attack = true

func _ready() -> void:
	go_to_walk_state()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
		
	match state:
		OrcsState.WALK:
			walk_state(delta)
		OrcsState.DEAD:
			dead_state(delta)
		OrcsState.ATTACK:
			attack_state(delta)
				
	move_and_slide()

	if position.y > 1000: 
		queue_free()

func go_to_walk_state():
	state = OrcsState.WALK
	anim.play("walk")
	velocity.x = SPEED * direction
	
func go_to_attack_state():
	if can_attack and state != OrcsState.DEAD:
		state = OrcsState.ATTACK
		anim.play("attack")
		velocity = Vector2.ZERO
		can_attack = false
		attack_cooldown.start()

func go_to_dead_state():
	state = OrcsState.DEAD
	anim.play("dead")
	hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	velocity = Vector2.ZERO

func walk_state(_delta):
	velocity.x = SPEED * direction
	
	if wall_detector.is_colliding() or not ground_detector.is_colliding():
		flip_direction()
		
	if player_detector.is_colliding() and player_detector.get_collider().has_method("take_damage"):
		go_to_attack_state()

func flip_direction():
	scale.x *= -1
	direction *= -1
	wall_detector.position.x *= -1
	ground_detector.position.x *= -1
	player_detector.position.x *= -1

func dead_state(_delta):
	pass

func attack_state(_delta):
	if anim.frame == 2 and anim.animation == "attack":
		for body in hitbox.get_overlapping_bodies():
			if body.has_method("take_damage"):
				body.take_damage()

func take_damage():
	if state != OrcsState.DEAD:
		go_to_dead_state()

func _on_animated_sprite_2d_animation_finished() -> void:
	match anim.animation:
		"attack":
			go_to_walk_state()
		"dead":
			queue_free()

func _on_attack_cooldown_timeout():
	can_attack = true
