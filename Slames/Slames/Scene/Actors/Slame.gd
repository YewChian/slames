extends KinematicBody2D
#starting init
var start_loc
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var attack_cooldown_time = 1000
var next_attack_time = 0
var attack_damage = 30
var now
var direct
var timer = null
var attacking = false
var target1
var target2
var target3
signal target_hit
onready var raycast1 =  get_node("Attack1")
onready var raycast2 =  get_node("Attack2")
onready var raycast3 =  get_node("Attack3")
onready var death_timer = get_node("Death")
onready var sd =  get_node("sd_cd")
var attackAnim_timer = null
onready var attackAnim = get_node("AttackTimer")
var spotDodge = 1
var shake_amount = 1.0
signal death

#Wands
onready var weaponPos = $WandPosition
var gun_data: = {
	fire = preload("res://Slames/EquippedWands/e_FireWand.tscn"),
	lightning = preload("res://Slames/EquippedWands/e_LightningWand.tscn"),
	ice = preload("res://Slames/EquippedWands/e_IceWand.tscn"),
}
onready var fire_equipped = false
onready var lightning_equipped = false
onready var ice_equipped = false
const fire_projectilePath = preload("res://Slames/EquippedWands/fire_projectile.tscn")
const lightning_projectilePath = preload("res://Slames/EquippedWands/lightning_projectile.tscn")
const ice_shardPath = preload("res://Slames/EquippedWands/ice_shard.tscn")

#MOVEMENT
var MAX_SPEED = 200
var motion = Vector2.ZERO
var last_direction
var move_speed = 20000
var speed

#DASHING
onready var dashcd = get_node("DashCoolDown")
onready var dashtimer = get_node("DashTimer")
onready var ice_dashcd = get_node("IceDashCoolDown")
onready var ice_dashtimer = get_node("IceDashTimer")
const ice_dash_speed = 100000
var canIceDash = true
var ice_dashing = false
var dashDirection = Vector2(1,0)
const dash_speed = 40000
var canDash = true
var dashing = false
var velocity

func _ready():
	start_loc = position
	target1 = raycast1.get_collider()
	target2 = raycast2.get_collider()
	target3 = raycast3.get_collider()
#	raycast1.set_enabled(false)
#	raycast2.set_enabled(false)
#	raycast3.set_enabled(false)
	death_timer.connect("timeout",self,"return_origin")
	attackAnim_timer = get_node("AttackTimer")
	dashcd.connect("timeout",self,"set_canDash_true")
	dashtimer.connect("timeout",self,"set_dash_false")
	attackAnim_timer.connect("timeout",self,"make_visible_attack")
	timer = get_node("SpotDodge")
	timer.set_wait_time(0.4)
	timer.connect("timeout",self,"sd_timeout")
	sd.connect("timeout",self,"sd_cooldown")
	#icedash
	dashtimer.connect("timeout",self,"set_ice_dash_false")
	dashcd.connect("timeout",self,"set_canIceDash_true")
	
func _physics_process(delta):
	if ($AnimationPlayer.current_animation == "ad_dr") or ($AnimationPlayer.current_animation == "ad_dl") or ($AnimationPlayer.current_animation == "ad_ur") or ($AnimationPlayer.current_animation == "ad_ul") or ($AnimationPlayer.current_animation == "Attack up") or ($AnimationPlayer.current_animation == "Attack left") or ($AnimationPlayer.current_animation == "Attack right") or ($AnimationPlayer.current_animation == "Attack") or (spotDodge == 0) or ($AnimationPlayer.current_animation == "Die"):
		return
	if Input.is_action_pressed("player2_up") and Input.is_action_pressed("player2_right"):
		last_direction = "diagonal_right"
		$AnimationPlayer.play("diagonal_right")
	elif Input.is_action_pressed("player2_up") and Input.is_action_pressed("player2_left"):
		last_direction = "diagonal_left"
		$AnimationPlayer.play("diagonal_left")
	elif Input.is_action_pressed("player2_down") and Input.is_action_pressed("player2_right"):
		last_direction = "diagonal_dright"
		$AnimationPlayer.play("diagonal_dright")
	elif Input.is_action_pressed("player2_down") and Input.is_action_pressed("player2_left"):
		last_direction = "diagonal_dleft"
		$AnimationPlayer.play("diagonal_dleft")
	elif Input.is_action_pressed("player2_down"):
		last_direction = "down"
		$AnimationPlayer.play("walkdown")
	elif Input.is_action_pressed("player2_right"):
		last_direction = "right"
		$AnimationPlayer.play("walkright")
	elif Input.is_action_pressed("player2_left"):
		last_direction = "left"
		$AnimationPlayer.play("walkleft")
	elif Input.is_action_pressed("player2_up"):
		last_direction = "up"
		$AnimationPlayer.play("walkup")
	elif Input.is_action_pressed("player2_up") and Input.is_action_pressed("player2_right"):
		last_direction = "diagonal_right"

	else:
		if(last_direction == "up"):
			$AnimationPlayer.play("idleup")
		elif(last_direction == "right"):
			$AnimationPlayer.play("idleright")
		elif(last_direction == "left"):
			$AnimationPlayer.play("idleleft")
		elif(last_direction == "diagonal_right"):
			$AnimationPlayer.play("idle_ur")
		elif(last_direction == "diagonal_left"):
			$AnimationPlayer.play("idle_ul")
		elif(last_direction == "diagonal_dright"):
			$AnimationPlayer.play("idle_dr")
		elif(last_direction == "diagonal_dleft"):
			$AnimationPlayer.play("idle_dl")
		else:
			$AnimationPlayer.play("idle")
			
	if Input.is_action_pressed("player2_spot"):
		if spotDodge == 1:
			$AnimationPlayer.play("SpotDodge")
			get_node("CollisionShape2D").disabled = true
			sd.start()
			spotDodge = 0
			timer.start()
		
		#ATTACKING
	if Input.is_action_pressed("Attack_P2"):
	# Check if player can attacka
		now = OS.get_ticks_msec()
		if now >= next_attack_time:
		# Play attack animation
			if ice_equipped == false and lightning_equipped == false and fire_equipped == false:
				if(last_direction == "up"):
					attackanim("Attack up")
				elif(last_direction == "right"):
					attackanim("Attack right")
				elif(last_direction == "left"):
					attackanim("Attack left")
				elif(last_direction == "diagonal_right"):
					attackanim("ad_ur")
				elif(last_direction == "diagonal_left"):
					attackanim("ad_ul")
				elif(last_direction == "diagonal_dright"):
					attackanim("ad_dr")
				elif(last_direction == "diagonal_dleft"):
					attackanim("ad_dl")
				else:
					attackanim("Attack")
			elif ice_equipped == true:
				shoot_ice()
			elif lightning_equipped == true:
				shoot_lightning()
			elif fire_equipped == true:
				shoot_fire()
			next_attack_time = now + attack_cooldown_time

	#if target1!= null or target2!= null or target3 != null:
	#	if target1.name.find("Player1") >= 0:
				#get_node("RichTextLabel").visible = not get_node("RichTextLabel").visible
	#		target1.hit()
	#elif target2.name.find("Player1") >= 0:
						#get_node("RichTextLabel").visible = not get_node("RichTextLabel").visible
	#	target2.hit()
	#elif target3.name.find("Player1") >= 0:
						#get_node("RichTextLabel").visible = not get_node("RichTextLabel").visible
	#	target3.hit()
	if Input.is_action_pressed("player2_dash"):
		if canDash == true:
			canDash = false
			dashing = true
			get_node("CollisionShape2D").disabled = true
			dashtimer.start()
			dashcd.start()
		
	var axis = get_input_axis()	
	if axis != Vector2.ZERO:
		#direct += 1
		$Attack2.cast_to = (axis.normalized() * 40)
		$Attack1.cast_to = (axis.normalized() * 40)
		#$Attack2.cast_to = axis.normalized() * 40
		$Attack3.cast_to = (axis.normalized() * 40)
	if(ice_dashing):
		speed = ice_dash_speed
	else:		
		speed = dash_speed if dashing else move_speed
	velocity = axis*speed*delta
	motion = move_and_slide(velocity)
	
func sd_cooldown():
	spotDodge = 1
func sd_timeout():
	get_node("CollisionShape2D").disabled = false
	
func get_input_axis():
	var axis = Vector2.ZERO
	axis.x = int(Input.is_action_pressed("player2_right")) - int(Input.is_action_pressed("player2_left"))
	axis.y = int(Input.is_action_pressed("player2_down")) - int(Input.is_action_pressed("player2_up"))
	return axis.normalized()
	
func apply_friction(amount):
	if motion.length() > amount:
		motion -= motion.normalized()*amount
	else:
		motion = Vector2.ZERO
		
func apply_movement(accerlation):
	motion += accerlation
	motion = motion.clamped(MAX_SPEED)
	
func hit():
	#play death animation
	return_origin()
	$death_mp3.play()
	$AnimationPlayer.play("Die")
	Lives.lives -= 1
	for gun in weaponPos.get_children():
		gun.queue_free()
	emit_signal("death")
	death_timer.start()
	fire_equipped = false
	ice_equipped = false
	lightning_equipped = false
	

func make_visible_attack():
	get_node("Attack").visible = not get_node("Attack").visible
#	disable_raycast()
	
func attackanim(direction):
	get_node("Attack").visible = not get_node("Attack").visible
	$AnimationPlayer.play(direction)
	$basic_attack_mp3.play()
	check_hit()
	attackAnim_timer.start()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
func enable_raycast():
	raycast1.set_enabled(true)
	raycast2.set_enabled(true)
	raycast3.set_enabled(true)
	
func disable_raycast():
	raycast1.set_enabled(false)
	raycast2.set_enabled(false)
	raycast3.set_enabled(false)
	
func set_dash_false():
	dashing = false
	get_node("CollisionShape2D").disabled = false
	
func check_hit():
	enable_raycast()
	print("Checking Hit...")
	if raycast1.is_colliding() or raycast1.is_colliding() or raycast1.is_colliding():
		if raycast1.is_colliding():
			print("hit")
			emit_signal("target_hit",raycast1.get_collider())
		elif raycast2.is_colliding():
			print("hit")
			emit_signal("target_hit",raycast2.get_collider())
		elif raycast3.is_colliding():
			print("hit")
			emit_signal("target_hit",raycast3.get_collider())
#		if target1.name.find("Player1") >= 0:
#			print("Hit...")
#			target1.hit()
#		if target2.name.find("Player1") >= 0:
#			print("Hit...")
#			target2.hit()
#		if target3.name.find("Player1") >= 0:
#			print("Hit...")
#			target3.hit()
func return_origin():
	position = start_loc
	get_node("CollisionShape2D").disabled = true
	yield(get_tree().create_timer(1), "timeout")
	get_node("CollisionShape2D").disabled = false
	
func set_canDash_true():
	canDash = true
	
func _something_entered() -> void:
	get_tree().queue_delete(self) # Replace with function body.
	
func pickup(gun_type:String):
	$pickup_mp3.play()
	for gun in weaponPos.get_children():
		gun.queue_free()

	var gun:Node2D = gun_data[gun_type].instance()
	weaponPos.add_child(gun)
	if gun_type == "fire":
		fire_equipped = true
	if gun_type == "lightning":
		lightning_equipped = true
	if gun_type == "ice":
		ice_equipped = true
		
	return "picked_up"
		
func shoot_fire():
	var fire_projectile = fire_projectilePath.instance()
	get_parent().add_child(fire_projectile)
	fire_projectile.global_position = $WandPosition.global_position
	fire_projectile.global_rotation = $WandPosition.global_rotation
	fire_projectile.velocity = Vector2.UP.rotated($WandPosition.global_rotation)
	
func shoot_lightning():
	var lightning_projectile = lightning_projectilePath.instance()
	get_parent().add_child(lightning_projectile)
	lightning_projectile.connect("hit_target",self,"return_origin")
	lightning_projectile.global_position = $WandPosition.global_position
	lightning_projectile.global_rotation = $WandPosition.global_rotation
	
func shoot_ice():
	if canIceDash == true:
		canIceDash = false
		ice_dashing = true
		get_node("CollisionShape2D").disabled = true
		ice_dashtimer.start()
		ice_dashcd.start()
		var ice_dash_duration = 0.1
		yield(get_tree().create_timer(ice_dash_duration), "timeout")
		ice_dashing = false
		get_node("CollisionShape2D").disabled = false
		move_speed = 0
		# instantiate ice
		var ice_shard = ice_shardPath.instance()	
		get_parent().add_child(ice_shard)
		ice_shard.connect("hit_target",self,"return_origin")
		ice_shard.global_position = $WandPosition.global_position
		ice_shard.global_rotation = $WandPosition.global_rotation
		yield(get_tree().create_timer(1), "timeout")		
		get_parent().remove_child(ice_shard)			
		move_speed = 20000
		canIceDash = true
	
