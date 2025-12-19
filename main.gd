extends Node3D


const WorldSize := Vector3(100,100,100)

func timed_message_init() -> void:
	var vp_size := get_viewport().get_visible_rect().size
	var msgrect := Rect2( vp_size.x * 0.1 ,vp_size.y * 0.4 , vp_size.x * 0.8 , vp_size.y * 0.25 )
	$TimedMessage.init(80, msgrect,
		"%s %s" % [
			ProjectSettings.get_setting("application/config/name"),
			ProjectSettings.get_setting("application/config/version")
			] )
	$TimedMessage.panel_hidden.connect(message_hidden)
	$TimedMessage.show_message("",0)
func message_hidden(_s :String) -> void:
	pass

func ui_panel_init() -> void:
	var vp_size := get_viewport().get_visible_rect().size
	var 짧은길이 :float = min(vp_size.x, vp_size.y)
	var panel_size := Vector2(vp_size.x/2 - 짧은길이/2, vp_size.y)
	$"왼쪽패널".size = panel_size
	$"왼쪽패널".custom_minimum_size = panel_size
	$오른쪽패널.size = panel_size
	$"오른쪽패널".custom_minimum_size = panel_size
	$오른쪽패널.position = Vector2(vp_size.x/2 + 짧은길이/2, 0)
func on_viewport_size_changed():
	ui_panel_init()

func label_demo() -> void:
	if $"오른쪽패널/LabelPerformance".visible:
		$"오른쪽패널/LabelPerformance".text = """%d FPS (%.2f mspf)
Currently rendering: occlusion culling:%s
%d objects
%dK primitive indices
%d draw calls""" % [
		Engine.get_frames_per_second(),1000.0 / Engine.get_frames_per_second(),
		get_tree().root.use_occlusion_culling,
		RenderingServer.get_rendering_info(RenderingServer.RENDERING_INFO_TOTAL_OBJECTS_IN_FRAME),
		RenderingServer.get_rendering_info(RenderingServer.RENDERING_INFO_TOTAL_PRIMITIVES_IN_FRAME) * 0.001,
		RenderingServer.get_rendering_info(RenderingServer.RENDERING_INFO_TOTAL_DRAW_CALLS_IN_FRAME),
		]
	if $"오른쪽패널/LabelInfo".visible:
		$"오른쪽패널/LabelInfo".text = "%s" % [ MovingCameraLight.GetCurrentCamera() ]
	$"왼쪽패널/Label".text = "MeshTrail %d" % [$MeshTrailContainer.get_child_count()]


var meshtrail_scene = preload("res://mesh_trail/mesh_trail.tscn")
func _ready() -> void:
	get_viewport().size_changed.connect(on_viewport_size_changed)
	ui_panel_init()
	timed_message_init()

	$OmniLight3D.position = Vector3(0,0,WorldSize.length())
	$OmniLight3D.omni_range = WorldSize.length()*2
	$BounceCameraLight.set_center_pos_far(Vector3.ZERO, Vector3(0, 0, WorldSize.z*2), WorldSize.length()*2)
	$FixedCameraLight.set_center_pos_far(Vector3.ZERO, Vector3(0, 0, WorldSize.z*2), WorldSize.length()*2)
	$MovingCameraLightHober.set_center_pos_far( Vector3.ZERO, Vector3(0, 0, WorldSize.z), WorldSize.length()*2)
	$MovingCameraLightAround.set_center_pos_far( Vector3.ZERO, Vector3(0, 0, WorldSize.z), WorldSize.length()*2)
	$AxisArrow3D.set_size(10)
	$WallBox.mesh.size = WorldSize

	var bound_size = WorldSize
	b_box = AABB( -bound_size/2, bound_size)
	velocity = Vector3( (randf()-0.5)*WorldSize.length()/3,(randf()-0.5)*WorldSize.length()/3,(randf()-0.5)*WorldSize.length()/3)
	for mt in MeshTrailTypeList:
		var ball = meshtrail_scene.instantiate(
			).set_ColorChange_OnBounce(
			).set_get_random_color_fn(random_color3
			).init( bounce, radius, randi_range(1,10), mt, Vector3.ZERO
			).set_speed(20,40)
		$MeshTrailContainer.add_child(ball)
	for mt in MeshTrailTypeList:
		var ball = meshtrail_scene.instantiate(
			).set_ColorChange_MeshGradient(
			).set_get_random_color_fn(random_color3
			).init( bounce, radius, randi_range(10,100), mt, Vector3.ZERO
			).set_speed(20,40)
		$MeshTrailContainer.add_child(ball)
	for mt in MeshTrailTypeList:
		var ball = meshtrail_scene.instantiate(
			).set_ColorChange_ByPosition(b_box
			).init( bounce, radius, randi_range(1,10), mt, Vector3.ZERO
			).set_speed(20,40)
		$MeshTrailContainer.add_child(ball)
	for mt in MeshTrailTypeList:
		var ball = meshtrail_scene.instantiate(
			).set_ColorChange_ByPositionFn(get_color_ByPosition
			).init( bounce, radius, randi_range(1,10), mt, Vector3.ZERO
			).set_speed(20,40)
		$MeshTrailContainer.add_child(ball)

func bounce(_oldpos:Vector3, pos :Vector3, radiusa :float) -> Dictionary:
	return Bounce.v3f(pos, b_box, radiusa)
func get_color_ByPosition(pos :Vector3) -> Color:
	var co :Color
	for i in 3:
		co[i] = (pos[i] - b_box.position[i]) / b_box.size[i]
	co = co.inverted()
	return co

var MeshTrailTypeList = ["♠","♣","♥","♦" ,"★","☆","♩","♪","♬"]

var color_list_light = NamedColorList.make_light_color_list()
var color_list_dark = NamedColorList.make_dark_color_list()
func random_color1() -> Color:
	return NamedColorList.color_list.pick_random()[0]
func random_color2() -> Color:
	return color_list_light.pick_random()[0]
func random_color3() -> Color:
	return color_list_dark.pick_random()[0]

var b_box :AABB
var radius := 1.5
var velocity :Vector3
func _process(delta: float) -> void:
	label_demo()

	for mt in $MeshTrailContainer.get_children():
		mt.move(delta)

	var now := Time.get_unix_time_from_system()
	var t := now /2.3
	if $BounceCameraLight.is_current_camera():
		velocity = $BounceCameraLight.bounce_within_aabb(delta, b_box, velocity, Vector3.ZERO, radius )
	elif $MovingCameraLightHober.is_current_camera():
		$MovingCameraLightHober.move_hober_around_z(t, Vector3.ZERO, (WorldSize.x+WorldSize.y)/2, WorldSize.length()*0.6 )
	elif $MovingCameraLightAround.is_current_camera():
		$MovingCameraLightAround.move_wave_around_y(t, Vector3.ZERO, (WorldSize.x+WorldSize.y)/2, WorldSize.length()*0.6 )

func _on_카메라변경_pressed() -> void:
	MovingCameraLight.NextCamera()

func _on_button_fov_up_pressed() -> void:
	MovingCameraLight.GetCurrentCamera().fov_camera_inc()

func _on_button_fov_down_pressed() -> void:
	MovingCameraLight.GetCurrentCamera().fov_camera_dec()

var key2fn = {
	KEY_ESCAPE:_on_button_esc_pressed,
	KEY_ENTER:_on_카메라변경_pressed,
	KEY_PAGEUP:_on_button_fov_up_pressed,
	KEY_PAGEDOWN:_on_button_fov_down_pressed,
}

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		var fn = key2fn.get(event.keycode)
		if fn != null:
			fn.call()
		if $FixedCameraLight.is_current_camera():
			var fi = FlyNode3D.Key2Info.get(event.keycode)
			if fi != null:
				FlyNode3D.fly_node3d($FixedCameraLight, fi)
	elif event is InputEventMouseButton and event.is_pressed():
		pass

func _on_button_esc_pressed() -> void:
	get_tree().quit()
