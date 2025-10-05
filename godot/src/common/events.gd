extends Node

@warning_ignore("unused_signal")
signal on_lose
@warning_ignore("unused_signal")
signal on_survived
@warning_ignore("unused_signal")
signal on_win
@warning_ignore("unused_signal")
signal level_ended()

@warning_ignore("unused_signal")
signal show_manual_requested
@warning_ignore("unused_signal")
signal show_list_requested
@warning_ignore("unused_signal")
signal show_passport_requested
@warning_ignore("unused_signal")
signal stamp_requested(destination: Types.Destination)


@warning_ignore("unused_signal")
signal request_next_day
@warning_ignore("unused_signal")
signal pre_day_started(quotas:Dictionary[Types.Destination, int], extra_souls:int, ruleset: RuleSet)
@warning_ignore("unused_signal")
signal day_started
@warning_ignore("unused_signal")
signal day_finished

@warning_ignore("unused_signal")
signal character_entered(character: Character)
@warning_ignore("unused_signal")
signal character_stamped(destination: Types.Destination, expected: Types.Destination)
@warning_ignore("unused_signal")
signal character_left

@warning_ignore("unused_signal")
signal job_changed(new_job:Types.JobTitle, previous_job:Types.JobTitle)
