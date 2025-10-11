class_name ClaimRule extends Rule

@export var topic:String 
@export var accepted_claim_values:Array[String] 
@export var rejected_claim_values:Array[String]

var allowed: Array[Claim]
var forbidden: Array[Claim]

func setup():
	#No setup required for default rules because they dont need claims
	if not topic: 
		return
		
	var all: Array[Claim] = Globals.character_generator.claims[topic]
	for claim in all:
		if claim.has_all_ids(accepted_claim_values) and not claim.has_any_id(rejected_claim_values):
			allowed.append(claim)
		
		if not claim.has_all_ids(accepted_claim_values) or claim.has_any_id(rejected_claim_values):
			forbidden.append(claim)
	

func is_met_by(character: Character) -> bool:
	#default rules are always met by anyone
	if not topic: 
		return true
	for claim in accepted_claim_values:
		if not character.has_claim(topic,claim):
			return false
	for claim in rejected_claim_values:
		if character.has_claim(topic,claim):
			return false
	return true
	

func make_character_meet(character: Character) -> void:
	if character.has_topic(topic) and not is_met_by(character):
		GSLogger.error("Character cannot meet rule")
		return
	
	character.claims.append(allowed.pick_random())
	

func make_character_not_meet(character: Character) -> void:
	if character.has_topic(topic) and is_met_by(character):
		GSLogger.error("Character cannot meet rule")
		return
	
	character.forbidden_topics.append(topic)
	

static func from_csv_line(cols:Array[String])->Rule:
	var rule = ClaimRule.new()
	#rule_name,religion,trait_name,accepted_values,rejected_values,custom,text,fate,day of implementation,end day
	rule.short_name = cols[0]
	rule.religion = lookup_religion(cols[1])
	rule.topic = cols[2] as String
	if not cols[3].is_empty():
		rule.accepted_claim_values = GameUtils.parse_list(cols[3])
	if not cols[4].is_empty():
		rule.rejected_claim_values = GameUtils.parse_list(cols[4])
	rule.description = cols[6]
	
	#TODO clean this up.
	var fate = lookup_fate(cols[7]) 	
	rule.met_destinations.append(fate)

	
	rule.start_day = int(cols[8])
	if cols[9]!='-':
		rule.end_day = int(cols[9]) 
	rule.priority = int(cols[10])
	rule.setup()
	GSLogger.info("Loaded rule %s" % rule.short_name)
	
	if rule.topic and rule.allowed.is_empty():
		GSLogger.error("Rule is not default and is not met by any claim")
		return null
	if rule.forbidden.is_empty():
		GSLogger.warn("Rule is not contradicted by any claim (we cannot ensure is_not_met)")
	
	return rule
	

func _to_string():
	return "Rule %s [%s]: Allowed: %s, Forbidden: %s, Met: %s, Unmet: %s" % [short_name, topic, allowed, forbidden, met_destinations, unmet_destinations]


static func lookup_fate(fname:String)->Types.Destination:
	#return Types.Destination.RETURN
	match fname:
		"paradise":
			return Types.Destination.HEAVEN
		"heaven":
			return Types.Destination.HEAVEN
		"hell":
			return Types.Destination.HELL
		"purgatory":
			return Types.Destination.PURGATORY
		"back to life":
			return Types.Destination.RETURN
		"reincarnation":
			return Types.Destination.REINCARNATE
		_:
			GSLogger.error("Can't find fate for rule")
			assert(false)
			return Types.Destination.RETURN
			
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
