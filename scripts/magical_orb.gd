extends Area2D

var speed = 85
var direction = 1

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	position.x += speed * delta * direction

func set_direction(player_direction):
	direction = player_direction
	anim.flip_h = direction < 0

func _on_self_destruct_timer_timeout() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemies"):
		area.get_parent().take_damage()
		queue_free()


func _on_body_entered(_body: Node2D) -> void:
	queue_free()
