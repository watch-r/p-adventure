extends CharacterBody2D

const SPEED = 300
const JUMP_VELOCITY = -850
var alive = true

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound
@onready var death_sound: AudioStreamPlayer2D = $DyingSound

func _physics_process(_delta: float) -> void:
	if (!alive):
		return
	handle_gravity(_delta)
	add_animation()
	handle_jump()
	handle_movement()
	move_and_slide()

func handle_gravity(_delta) -> void:
	if not is_on_floor():
		velocity += get_gravity() * _delta

func handle_jump() -> void:
	if Input.is_action_just_pressed('jump') and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_sound.play()
	if not is_on_floor():
		animated_sprite_2d.animation = "jumping"

func handle_movement() -> void:
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	# flip direction
	if direction == 1.0:
		animated_sprite_2d.flip_h = false
	elif direction == -1.0:
		animated_sprite_2d.flip_h = true

func handle_death() -> void:
	alive = false
	animated_sprite_2d.animation = "dying"
	death_sound.play()

func add_animation() -> void:
	if velocity.x > 1 or velocity.x < -1:
		animated_sprite_2d.animation = "running"
	else:
		animated_sprite_2d.animation = "idle"
