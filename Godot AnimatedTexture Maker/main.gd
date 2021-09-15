extends Control


#var fps: int = 1
#var oneshot: bool = false
onready var texture := AnimatedTexture.new()
var formats := [
	"bmp",
	"dds",
	"exr",
	"hdr",
	"jpg",
	"jpeg",
	"png",
	"tga",
	"svg",
	"svgz",
	"webp",
]

# Nodes
onready var texture_rect = $CenterContainer/VBoxContainer/TextureRect
onready var file_dialog = $FileDialog
onready var save_button = $CenterContainer/VBoxContainer/HBoxSave/SaveButton


func _ready():
	save_button.disabled = true
	get_tree().connect("files_dropped", self, "_on_files_dropped")
	
	for format in formats:
		file_dialog.add_filter("*.%s; %s Images" % [format, format.capitalize()])


func generate(input_files: PoolStringArray):
	# Set the number of frames
	texture.frames = input_files.size()
	
	# Load each image
	for i in input_files.size():
		var tex = ImageTexture.new()
		var img = Image.new()
		img.load(input_files[i])
		tex.create_from_image(img)
		tex.storage = ImageTexture.STORAGE_COMPRESS_LOSSLESS
		texture.set_frame_texture(i, tex)
	
	# Show the resulted animtex
	texture_rect.texture = texture


func _on_SaveButton_pressed():
	var file_name = "AnimatedTexture %s.%s.%s.tres" % [
		OS.get_datetime().hour,
		OS.get_datetime().minute,
		OS.get_datetime().second
	]
	var dir_path = OS.get_executable_path().get_base_dir()
	
	var dir = Directory.new()
	dir.make_dir(dir_path)
	ResourceSaver.save(dir_path.plus_file(file_name), texture)


func _on_FileDialog_files_selected(paths):
	save_button.disabled = false
	generate(paths)

func _on_ImportButton_pressed():
	file_dialog.popup_centered()

func _on_FpsSpinBox_value_changed(value):
	texture.fps = value

func _on_OneshotCheckButton_toggled(button_pressed):
	texture.oneshot = button_pressed

func _on_files_dropped(files, screen):
	var valid_files := []
	for file in files:
		for format in formats:
			if file.ends_with(".%s" % format):
				valid_files.append(file)
	
	save_button.disabled = false
	generate(valid_files)
