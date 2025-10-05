class_name ClaimRule extends Rule


func _init() -> void:
	pass

func is_met_by(character: Character) -> bool:
	for claim in accepted_claim_values:
		if not character.has_claim(topic,claim):
			return false
	for claim in rejected_claim_values:
		if character.has_claim(topic,claim):
			return false
	return true
	

func should_apply(character: Character) -> bool:
	return religion == Types.Religion.UNKNOWN or religion == character.religion
	

func make_character_meet(_character: Character) -> void:
	pass
	

func make_character_not_meet(_character: Character) -> void:
	pass
	
static func from_csv_line(cols:Array[String])->Rule:
	var rule = ClaimRule.new()
	#rule_name,religion,trait_name,accepted_values,rejected_values,custom,text,fate,day of implementation,end day
	rule.short_name = cols[0]
	rule.religion = lookup_religion(cols[1])
	rule.topic = cols[2] as String
	rule.accepted_claim_values=[] if cols[3]=="" else cols[3].split(";") as Array[String]
	rule.rejected_claim_values=[] if cols[4]=="" else cols[4].split(";") as Array[String]
	rule.description = cols[6]
	rule.met_destinations=lookup_fate(cols[7])

	if rule.description.begins_with("All"):
			rule.unmet_destinations.append_array(Types.Destination.values())
	else:
		for d in Types.Destination.values():
			if not d in rule.met_destinations:
				rule.unmet_destinations.append(d)
	rule.start_day = int(cols[8])
	if cols[9]!='-':
		rule.end_day = int(cols[9]) 
	rule.priority = int(cols[10])
	return rule

static func lookup_fate(fname:String)->Array[Types.Destination]:
	#return Types.Destination.RETURN
	match fname:
		"paradise":
			return [Types.Destination.HEAVEN]
		"heaven":
			return [Types.Destination.HEAVEN]
		"hell":
			return [Types.Destination.HELL]
		"purgatory":
			return [Types.Destination.PURGATORY]
		"back to life":
			return [Types.Destination.RETURN]
		"reincarnation":
			return [Types.Destination.REINCARNATE]
		_:
			GSLogger.error("Can't find fate for rule")
			assert(false)
			return [0]
			
static func lookup_religion(rname:String)->Types.Religion:
	match rname:		
		"snail_religion":
			return Types.Religion.SNAIL
		"star_religion":
			return Types.Religion.STAR
		"tea_religion":
			return Types.Religion.TEA
		"sect_religion":
			return Types.Religion.LUMINARA
		_:
			GSLogger.warn("Can't find religion %s" % rname)
			return Types.Religion.UNKNOWN
