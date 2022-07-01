extends KinematicBody2D
#starting init
var start_loc
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var velo = Vector2()
var attack_cooldown_time = 1000
var next_attack_time = 0
var now
signal reload
var direct
var timer = null
onready var sd =  get_node("sd_cd")
var attackAnim_timer = null
var target1
var target2
var target3
signal target_hit
onready var raycast1 = get_node("Attack1")
onready var raycast2 = get_node("Attack2")
onready var raycast3 = get_node("Attack3")
onready var death_timer = get_node("Death")
onready var attackAnim = get_node("AttackTimer")
var spotDodge = 1
var shake_amount = 1.0
signal death

#GUN
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
var dashDirection = Vector2(1,0)
const dash_speed = 40000
const ice_dash_speed = 60000
var canDash = true
var canIceDash = true
var dashing = false
var ice_dashing = false
var velocity

func _ready():
	start_loc = position
	target1 = raycast1.get_collider()
	target2 = raycast2.get_collider()
	target3 = raycast3.get_collider()
	death_timer.connect("timeout",self,"restart_loc")
	attackAnim.connect("timeout",self,"make_visible_attack")
	sd.connect("timeout",self,"sd_cooldown")
	timer = get_node("SpotDodge")
	timer.set_wait_time(0.4)
	timer.connect("timeout",self,"sd_timeout")
	dashtimer.connect("timeout",self,"set_dash_false")
	dashcd.connect("timeout",self,"set_canDash_true")
	#icedash
	dashtimer.connect("timeout",self,"set_ice_dash_false")
	dashcd.connect("timeout",self,"set_canIceDash_true")
	
func _physics_process(delta):
	if ($AnimationPlayer.current_animation == "ad_ur") or ($AnimationPlayer.current_animation == "ad_ul") or ($AnimationPlayer.current_animation == "ad_dl") or ($AnimationPlayer.current_animation == "ad_dr") or ($AnimationPlayer.current_animation == "Attack up") or ($AnimationPlayer.current_animation == "Attack left") or ($AnimationPlayer.current_animation == "Attack right") or ($AnimationPlayer.current_animation == "Attack") or (spotDodge == 0) or ($AnimationPlayer.current_animation == "Die"):
		return
	# Turn RayCast2D toward movement direction
	if Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_right"):
		last_direction = "d_ur"
		$AnimationPlayer.play("d_ur")
	elif Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_left"):
		last_direction = "d_ul"
		$AnimationPlayer.play("d_ul")
	elif Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_right"):
		last_direction = "d_dr"
		$AnimationPlayer.play("d_dr")
	elif Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_left"):
		last_direction = "d_dl"
		$AnimationPlayer.play("d_dl")
		
	elif Input.is_action_pressed("ui_down"):
		last_direction = "down"
		$AnimationPlayer.play("Walk down")
	elif Input.is_action_pressed("ui_right"):
		last_direction = "right"
		$AnimationPlayer.play("Walk right")
	elif Input.is_action_pressed("ui_left"):
		last_direction = "left"
		$AnimationPlayer.play("Walk left")
	elif Input.is_action_pressed("ui_up"):
		last_direction = "up"
		$AnimationPlayer.play("Walk up")
	else:
		if(last_direction == "up"):
			$AnimationPlayer.play("Idle up")
		elif(last_direction == "right"):
			$AnimationPlayer.play("Idle right")
		elif(last_direction == "left"):
			$AnimationPlayer.play("Idle left")
		elif(last_direction == "d_ur"):
			$AnimationPlayer.play("idle_ur")
		elif(last_direction == "d_ul"):
			$AnimationPlayer.play("idle_ul")
		elif(last_direction == "d_dr"):
			$AnimationPlayer.play("idle_dr")
		elif(last_direction == "d_dl"):
			$AnimationPlayer.play("idle_dl")
		else:
			$AnimationPlayer.play("Idle")
	if Input.is_action_pressed("Attack"):
	# Check if player can attack
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
				elif(last_direction == "d_ur"):
					attackanim("ad_ur")
				elif(last_direction == "d_ul"):
					attackanim("ad_ul")
				elif(last_direction == "d_dr"):
					attackanim("ad_dr")
				elif(last_direction == "d_dl"):
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
			
	if Input.is_action_pressed("ui_spot"):
		if spotDodge == 1:
			$AnimationPlayer.play("spotDodge")
			get_node("Colider").disabled = true
			sd.start()
			spotDodge = 0
			timer.start()
				
	if Input.is_action_pressed("ui_dash"):
		if canDash == true:
			canDash = false
			dashing = true
			get_node("Colider").disabled = true
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
	get_node("Colider").disabled = false
	
func get_input_axis():
	var axis = Vector2.ZERO
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	axis.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
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
	emit_signal("death")
	return_origin()
	RedSlimeLives.lives -= 1
	for gun in weaponPos.get_children():
		gun.queue_free()
	$AnimationPlayer.play("Die")
	death_timer.start()
	fire_equipped = false
	ice_equipped = false
	lightning_equipped = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
func restart_loc():
	position = start_loc	
	
func make_visible_attack():
	get_node("Attack").visible = not get_node("Attack").visible
#	disable_raycast()
	
func attackanim(direction):
	get_node("Attack").visible = not get_node("Attack").visible
	$AnimationPlayer.play(direction)
#	camera.set_offset(Vector2( \
#		rand_range(-1.0, 1.0) * shake_amount, \
#		rand_range(-1.0, 1.0) * shake_amount \
#	))
	check_hit()
	attackAnim.start()
	
func set_dash_false():
	dashing = false
	get_node("Colider").disabled = false
func set_ice_dash_false():
	ice_dashing = false
	get_node("Colider").disabled = false
func return_origin():
	position = start_loc
func set_canDash_true():
	canDash = true
	
func check_hit():
	print("Checking Hit...")
	enable_raycast()
	if raycast1.is_colliding() or raycast1.is_colliding() or raycast1.is_colliding():
		if raycast1.is_colliding():
			emit_signal("target_hit",raycast1.get_collider())
		elif raycast2.is_colliding():
			emit_signal("target_hit",raycast2.get_collider())
		elif raycast3.is_colliding():
			emit_signal("target_hit",raycast3.get_collider())

func enable_raycast():
	raycast1.set_enabled(true)
	raycast2.set_enabled(true)
	raycast3.set_enabled(true)
	
func disable_raycast():
	raycast1.set_enabled(false)
	raycast2.set_enabled(false)
	raycast3.set_enabled(false)

func pickup(gun_type:String):
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

func shoot_fire():
	var fire_projectile = fire_projectilePath.instance()
	get_parent().add_child(fire_projectile)
	fire_projectile.connect("hit_target",self,"return_origin")
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
	#dash
	if canIceDash == true:
		canIceDash = false
		ice_dashing = true
		get_node("Colider").disabled = true
		ice_dashtimer.start()
		ice_dashcd.start()
		var ice_dash_duration = 0.1
		yield(get_tree().create_timer(ice_dash_duration), "timeout")
		#stop dash
		ice_dashing = false
		get_node("Colider").disabled = false
		move_speed = 0
		# instantiate ice
		var ice_shard = ice_shardPath.instance()	
		get_parent().add_child(ice_shard)
		ice_shard.global_position = $WandPosition.global_position
		ice_shard.global_rotation = $WandPosition.global_rotation
		yield(get_tree().create_timer(1), "timeout")		
		get_parent().remove_child(ice_shard)	
		move_speed = 20000
		canIceDash = true
	
func _on_TileMap_somethingentered() -> void:
	get_tree().queue_delete(self)
