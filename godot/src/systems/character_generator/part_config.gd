class_name PartConfig extends Resource

@export var part: String
@export var variant: String

@export var back_texture: Texture2D
@export var front_texture: Texture2D

@export var back_no_recolor: bool
@export var front_no_recolor: bool

@export var back_color: Character.ColorChannel
@export var front_color: Character.ColorChannel

@export var religion: Types.Religion

@export var gender: Character.Gender

@export var allowed_parts: Dictionary[String, Array]
