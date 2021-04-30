extends Control


var format := "%s"
var fps: int = 1
var oneshot:bool = false
onready var texture := AnimatedTexture.new()

func _on_LineEdit_text_changed(new_text):
	if "%s" in new_text:
		format = new_text
	print(format)

func generate(input_files: PoolStringArray):
	#var texture = AnimatedTexture.new()
	
	texture.frames = input_files.size()
	
	for i in input_files.size():
		var tex = ImageTexture.new()
		var img = Image.new()
		img.load(input_files[i])
		tex.create_from_image(img)
		tex.storage = ImageTexture.STORAGE_COMPRESS_LOSSLESS
		texture.set_frame_texture(i, tex)
	
	$TextureRect.texture = texture

func _on_SaveButton_pressed():
	var file_name = "AnimatedTexture %s.%s.%s.tres" % [OS.get_datetime().hour, OS.get_datetime().minute, OS.get_datetime().second]
	var dir_path = OS.get_executable_path().get_base_dir().plus_file("output")
	
	var dir = Directory.new()
	dir.make_dir(dir_path)
	ResourceSaver.save(dir_path.plus_file(file_name), texture)


#func change_settings(fps: int, oneshot: bool):
#	texture.fps = fps
#	texture.oneshot = oneshot


func _on_FileDialog_files_selected(paths):
	print(paths)
	generate(paths)


func _on_ImportButton_pressed():
	$FileDialog.popup_centered()

func _on_FpsSpinBox_value_changed(value):
	texture.fps = value

func _on_OneshotCheckButton_toggled(button_pressed):
	texture.oneshot = button_pressed

