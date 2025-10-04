@tool
extends EditorScript

const ASSET_PATH = "res://assets/gfx/Characters"
const RESOURCE_PATH = "res://src/resources/character_config"

const OVERWRITE = true

func _run() -> void:
	var assets := _find_assets(ASSET_PATH)
	var dict := _to_dictionary(assets)
	
	for bodypart in dict:
		var resource_path = RESOURCE_PATH.path_join(bodypart)
		if !DirAccess.dir_exists_absolute(resource_path):
			DirAccess.make_dir_absolute(resource_path)
		
		for variant in dict[bodypart]:
			_process_asset(bodypart, variant, dict[bodypart][variant])
			

func _find_assets(path: String) -> Array[String]:
	var assets: Array[String]
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
				assets.append_array(_find_assets(path.path_join(file_name)))
			else:
				if file_name.get_extension() != "import":
					print("Found file: " + file_name)
					assets.append(path.path_join(file_name))
				
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	return assets
	

func _process_asset(bodypart: String, variant: String, assets: Array[String]) -> void:
	var resource_path = RESOURCE_PATH.path_join(bodypart).path_join(variant + ".tres")
	if FileAccess.file_exists(resource_path):
		print("Resource %s already exists" % resource_path)
		if not OVERWRITE:
			return
		
	var resource:PartConfig
	
	if bodypart == "torso":
		resource = TorsoConfig.new()
	else:
		resource = PartConfig.new()
	
	resource.part = bodypart
	resource.variant = variant
	
	for asset in assets:
		var parts = _filename_parts(asset)
		if parts.size() > 2:
			if parts[2] == "back":
				resource.back_texture = load(asset)
				resource.back_no_recolor = parts.back() == "norecolor"
			if parts[2] == "front":
				resource.front_texture = load(asset)
				resource.front_no_recolor = parts.back() == "norecolor"
		else:
			resource.back_texture = load(asset)
			resource.back_no_recolor = parts.back() == "norecolor"
		
	match bodypart:
		"torso":
			resource.back_color = Character.ColorChannel.CLOTHES_1
			resource.front_color = Character.ColorChannel.CLOTHES_2
		"face", "nose":
			resource.back_color = Character.ColorChannel.SKIN
			resource.front_color = Character.ColorChannel.SKIN
		"eyes", "mouth":
			resource.back_no_recolor = true
			resource.front_color = Character.ColorChannel.SKIN
		"hair", "eyebrows", "facialhair":
			resource.back_color = Character.ColorChannel.HAIR
			resource.front_color = Character.ColorChannel.HAIR
		_:
			resource.back_no_recolor = true
			resource.front_no_recolor = true
	
	if variant.to_lower().contains("snail"):
		resource.religion = Types.Religion.SNAIL
	if variant.to_lower().contains("star"):
		resource.religion = Types.Religion.STAR
	if variant.to_lower().contains("tea"):
		resource.religion = Types.Religion.TEA
	if variant.to_lower().contains("luminara") or variant.to_lower().contains("cross"):
		resource.religion = Types.Religion.LUMINARA
	
	print("Saving resource %s" % resource_path)
	ResourceSaver.save(resource, resource_path)
	

func _to_dictionary(assets: Array[String]) -> Dictionary[String, Dictionary]:
	var dict : Dictionary[String, Dictionary]
	
	for asset in assets:
		var parts: Array[String] = _filename_parts(asset)
		var bodypart = parts[0]
		var variant = parts[1]
		
		if not bodypart in dict:
			var part_dict : Dictionary[String, Array]
			dict[bodypart] = part_dict
		
		if not variant in dict[bodypart]:
			var variant_array: Array[String]
			dict[bodypart][variant] = variant_array
		
		dict[bodypart][variant].append(asset)
		
	return dict
	

func _filename_parts(path: String) -> Array[String]:
	var filename = path.get_file().trim_suffix("." + path.get_extension())
	var parts: Array[String]
	parts.assign(filename.split("_"))
	return parts
	
