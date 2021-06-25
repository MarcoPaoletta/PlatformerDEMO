extends KinematicBody2D

var speed = 50
var velocity = Vector2()
export var direction = -1
export var detects_clifs = true

func _ready():
	if direction == 1:
		$AnimatedSprite.flip_h = true 
	$FloorChecker.position.x = $CollisionShape2D.shape.get_extents().x * direction
	$FloorChecker.enabled = detects_clifs
	if detects_clifs:
		set_modulate(Color(1.2,0.5,1))
	
func _physics_process(delta):
	if is_on_wall() or not $FloorChecker.is_colliding() and detects_clifs and is_on_floor():
		direction = direction * -1
		$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
		$FloorChecker.position.x = $CollisionShape2D.shape.get_extents().x * direction
	velocity.y += 20
	velocity.x = speed * direction
	velocity = move_and_slide(velocity,Vector2.UP)

func _on_TopChecker_body_entered(body):
	$AnimatedSprite.play("squashed")
	speed = 0
	set_collision_layer_bit(4, false)
	set_collision_mask_bit(0, false)
	$TopChecker.set_collision_layer_bit(4, false)
	$TopChecker.set_collision_mask_bit(0, false)
	$SidesCheker.set_collision_layer_bit(4, false)
	$SidesCheker.set_collision_mask_bit(0, false)
	$Timer.start()
	body.bounce()
	$SoundSquash.play()
	yield($Timer,"timeout")
	queue_free()

func _on_SidesCheker_body_entered(body):
	body.ouch(position.x)
	
# Timer "timeout" signal, but I replaced using YIELD
