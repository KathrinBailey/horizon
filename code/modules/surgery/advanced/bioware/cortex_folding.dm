/datum/surgery/advanced/bioware/cortex_folding
	name = "Cortex Folding"
	desc = "A surgical procedure which modifies the cerebral cortex into a complex fold, giving space to non-standard neural patterns."
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/incise,
		/datum/surgery_step/incise,
		/datum/surgery_step/fold_cortex,
		/datum/surgery_step/close)
	possible_locs = list(BODY_ZONE_HEAD)
	target_mobtypes = list(/mob/living/carbon/human)
	bioware_target = BIOWARE_CORTEX

/datum/surgery/advanced/bioware/cortex_folding/can_start(mob/user, mob/living/carbon/target)
	var/obj/item/organ/brain/target_brain = target.getorganslot(ORGAN_SLOT_BRAIN)
	if(!target_brain)
		return FALSE
	return ..()

/datum/surgery_step/fold_cortex
	name = "fold cortex"
	accept_hand = TRUE
	time = 125

/datum/surgery_step/fold_cortex/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, SPAN_NOTICE("You start folding [target]'s outer cerebral cortex into a fractal pattern."),
		SPAN_NOTICE("[user] starts folding [target]'s outer cerebral cortex into a fractal pattern."),
		SPAN_NOTICE("[user] begins to perform surgery on [target]'s brain."))

/datum/surgery_step/fold_cortex/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	display_results(user, target, SPAN_NOTICE("You fold [target]'s outer cerebral cortex into a fractal pattern!"),
		SPAN_NOTICE("[user] folds [target]'s outer cerebral cortex into a fractal pattern!"),
		SPAN_NOTICE("[user] completes the surgery on [target]'s brain."))
	new /datum/bioware/cortex_fold(target)
	return ..()

/datum/surgery_step/fold_cortex/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(target.getorganslot(ORGAN_SLOT_BRAIN))
		display_results(user, target, SPAN_WARNING("You screw up, damaging the brain!"),
			SPAN_WARNING("[user] screws up, damaging the brain!"),
			SPAN_NOTICE("[user] completes the surgery on [target]'s brain."))
		target.adjustOrganLoss(ORGAN_SLOT_BRAIN, 60)
		target.gain_trauma_type(BRAIN_TRAUMA_SEVERE, TRAUMA_RESILIENCE_LOBOTOMY)
	else
		user.visible_message(SPAN_WARNING("[user] suddenly notices that the brain [user.p_they()] [user.p_were()] working on is not there anymore."), SPAN_WARNING("You suddenly notice that the brain you were working on is not there anymore."))
	return FALSE

/datum/bioware/cortex_fold
	name = "Cortex Fold"
	desc = "The cerebral cortex has been folded into a complex fractal pattern, and can support non-standard neural patterns."
	mod_type = BIOWARE_CORTEX

/datum/bioware/cortex_fold/on_gain()
	. = ..()
	ADD_TRAIT(owner, TRAIT_SPECIAL_TRAUMA_BOOST, EXPERIMENTAL_SURGERY_TRAIT)

/datum/bioware/cortex_fold/on_lose()
	REMOVE_TRAIT(owner, TRAIT_SPECIAL_TRAUMA_BOOST, EXPERIMENTAL_SURGERY_TRAIT)
	return ..()
