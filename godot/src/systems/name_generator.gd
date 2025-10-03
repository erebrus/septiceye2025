class_name SoulNameGenerator extends Node

var name_generator := m12NameGenerator.new()
var female_pool := name_generator.generate_name_pool([m12NameGeneratorAutoTags.FEMALE,m12NameGeneratorAutoTags.ENGLISH])
var male_pool := name_generator.generate_name_pool([m12NameGeneratorAutoTags.MALE,m12NameGeneratorAutoTags.ENGLISH])
var surname_pool := name_generator.generate_name_pool([m12NameGeneratorAutoTags.SURNAME,m12NameGeneratorAutoTags.ENGLISH])

	
func generate_female_name()->String:
	return "%s %s" % [female_pool.pick_random(), surname_pool.pick_random()]
	
func generate_male_name()->String:
	return "%s %s" % [female_pool.pick_random(), surname_pool.pick_random()]
