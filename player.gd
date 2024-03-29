extends Area2D

signal hit
var health = 0
@export var speed = 200 #How fast the player will move (pixels/sec)
var screen_size # Size of the game window
@export var projectile_scene: PackedScene
var shootSound := AudioStreamPlayer.new()
var playerDeath := AudioStreamPlayer.new()
var elapsed = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()
	add_child(shootSound)
	add_child(playerDeath)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	elapsed += delta
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	# SHOOTING PROJECTILE
	var aim_direction = Input.get_vector("fly_left", "fly_right", "fly_up", "fly_down")
	var currently_aiming = !(aim_direction == Vector2.ZERO)
	if elapsed > 0.20:
		if currently_aiming:
			shoot(aim_direction)
			elapsed = 0
		if Input.is_action_pressed("fly_down"):
			shootSound.stream = load("res://audio/shoot.wav")
			shootSound.play()
		if Input.is_action_pressed("fly_up"):
			shootSound.stream = load("res://audio/shoot.wav")
			shootSound.play()
		if Input.is_action_pressed("fly_left"):
			shootSound.stream = load("res://audio/shoot.wav")
			shootSound.play()
		if Input.is_action_pressed("fly_right"):
			shootSound.stream = load("res://audio/shoot.wav")
			shootSound.play()
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		# See the note below about boolean assignment.
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		#$AnimatedSprite2D.flip_v = velocity.y > 0

# SHOOTING PROJECTILE
func shoot(aim_direct):
	var projectile = projectile_scene.instantiate()
	projectile.look_at(aim_direct)
	get_parent().add_child(projectile)
	projectile.position = global_position
	projectile.apply_impulse(aim_direct*500)
	
signal update_health(h)
func _on_body_entered(_body):
	health+= 25
	if(health <= 100):
		update_health.emit(health)
	if(health >= 100):	
		playerDeath.stream = load("res://audio/playerDeath.wav")
		playerDeath.play()
		hide() # Player disappears after being hit.
		hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
		$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	health = 0
	update_health.emit(health)
	position = pos
	show()
	$CollisionShape2D.disabled = false
