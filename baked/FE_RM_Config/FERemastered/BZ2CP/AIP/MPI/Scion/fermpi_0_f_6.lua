
function InitAIPLua(team)
    AIPUtil.print(team, "Running AIP Lua Condition Script for CPU Team: " .. team);
end

function validate(planName, conditions)
  msg = ''
  go = true
  for k, v in pairs(conditions) do
    msg = msg .. k .. ':' .. tostring(v) .. ' '
    go = go and v
  end

  if (go) then
      return true, planName .. ": " .. msg .. ". Proceeding...";
  else
      return false, planName .. ": " .. msg .. ". Halting plan.";
  end
end

function validatePlan7(team, time)
  return validate('fvturr', {
    HAS_1_VIRTUAL_CLASS_RECYCLERBUILDING = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_RECYCLERBUILDING", 'sameteam', true) >= 1
   , HAS_1_VIRTUAL_CLASS_EXTRACTOR_GROUP = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_EXTRACTOR_GROUP", 'sameteam', true) >= 1
  })
end
function validatePlan8(team, time)
  return validate('fvserv', {
    HAS_1_VIRTUAL_CLASS_RECYCLERBUILDING = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_RECYCLERBUILDING", 'sameteam', true) >= 1
   , HAS_1_VIRTUAL_CLASS_SUPPLYDEPOT = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_SUPPLYDEPOT", 'sameteam', true) >= 1
  })
end
function validatePlan10(team, time)
  return validate('fvatank', {
    LACKS_6_DefendUnit = AIPUtil.CountUnits(team, "DefendUnit", 'sameteam', true) < 6
   , HAS_3_VIRTUAL_CLASS_EXTRACTOR_GROUP = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_EXTRACTOR_GROUP", 'sameteam', true) >= 3
   , HAS_1_VIRTUAL_CLASS_FACTORY_U = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_FACTORY_U", 'sameteam', true) >= 1
   , HAS_1_VIRTUAL_CLASS_OVERSEER_ARRAY = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_OVERSEER_ARRAY", 'sameteam', true) >= 1
   , HAS_1_VIRTUAL_CLASS_ARMORY = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_ARMORY", 'sameteam', true) >= 1
  })
end
function validatePlan11(team, time)
  return validate('fvwalk', {
    LACKS_6_DefendUnit = AIPUtil.CountUnits(team, "DefendUnit", 'sameteam', true) < 6
   , HAS_2_VIRTUAL_CLASS_EXTRACTOR_GROUP = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_EXTRACTOR_GROUP", 'sameteam', true) >= 2
   , HAS_1_VIRTUAL_CLASS_FACTORY_U = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_FACTORY_U", 'sameteam', true) >= 1
   , HAS_1_VIRTUAL_CLASS_SUPPLYDEPOT = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_SUPPLYDEPOT", 'sameteam', true) >= 1
   , HAS_1_VIRTUAL_CLASS_ARMORY = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_ARMORY", 'sameteam', true) >= 1
  })
end
function validatePlan12(team, time)
  return validate('fvartl', {
    LACKS_6_DefendUnit = AIPUtil.CountUnits(team, "DefendUnit", 'sameteam', true) < 6
   , HAS_2_VIRTUAL_CLASS_EXTRACTOR_GROUP = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_EXTRACTOR_GROUP", 'sameteam', true) >= 2
   , HAS_1_VIRTUAL_CLASS_FACTORY_U = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_FACTORY_U", 'sameteam', true) >= 1
   , HAS_1_VIRTUAL_CLASS_OVERSEER_ARRAY = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_OVERSEER_ARRAY", 'sameteam', true) >= 1
  })
end
function validatePlan13(team, time)
  return validate('fvtank', {
    LACKS_6_DefendUnit = AIPUtil.CountUnits(team, "DefendUnit", 'sameteam', true) < 6
   , HAS_1_VIRTUAL_CLASS_EXTRACTOR_GROUP = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_EXTRACTOR_GROUP", 'sameteam', true) >= 1
   , HAS_1_VIRTUAL_CLASS_FACTORY_U = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_FACTORY_U", 'sameteam', true) >= 1
   , HAS_1_VIRTUAL_CLASS_ANTENNA_MOUND = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_ANTENNA_MOUND", 'sameteam', true) >= 1
   , LACKS_1_VIRTUAL_CLASS_OVERSEER_ARRAY = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_OVERSEER_ARRAY", 'sameteam', true) < 1
  })
end
function validatePlan14(team, time)
  return validate('fvarch', {
    LACKS_6_DefendUnit = AIPUtil.CountUnits(team, "DefendUnit", 'sameteam', true) < 6
   , HAS_1_VIRTUAL_CLASS_EXTRACTOR_GROUP = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_EXTRACTOR_GROUP", 'sameteam', true) >= 1
   , HAS_1_VIRTUAL_CLASS_FACTORY = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_FACTORY", 'sameteam', true) >= 1
   , HAS_1_VIRTUAL_CLASS_ANTENNA_MOUND = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_ANTENNA_MOUND", 'sameteam', true) >= 1
  })
end
function validatePlan15(team, time)
  return validate('fvsent', {
    LACKS_6_DefendUnit = AIPUtil.CountUnits(team, "DefendUnit", 'sameteam', true) < 6
   , HAS_1_VIRTUAL_CLASS_EXTRACTOR_GROUP = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_EXTRACTOR_GROUP", 'sameteam', true) >= 1
   , HAS_1_VIRTUAL_CLASS_FACTORY = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_FACTORY", 'sameteam', true) >= 1
   , LACKS_1_VIRTUAL_CLASS_FACTORY_U = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_FACTORY_U", 'sameteam', true) < 1
  })
end
function validatePlan16(team, time)
  return validate('fvscout', {
    LACKS_6_DefendUnit = AIPUtil.CountUnits(team, "DefendUnit", 'sameteam', true) < 6
   , HAS_1_VIRTUAL_CLASS_EXTRACTOR_GROUP = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_EXTRACTOR_GROUP", 'sameteam', true) >= 1
   , LACKS_1_VIRTUAL_CLASS_FACTORY_U = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_FACTORY_U", 'sameteam', true) < 1
  })
end
function validatePlan17(team, time)
  return validate('fbspir', {
    HAS_2_VIRTUAL_CLASS_EXTRACTOR_GROUP = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_EXTRACTOR_GROUP", 'sameteam', true) >= 2
  })
end
function validatePlan18(team, time)
  return validate('fbkiln', {
    LACKS_1_VIRTUAL_CLASS_FACTORY = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_FACTORY", 'sameteam', true) < 1
   , HAS_1_VIRTUAL_CLASS_EXTRACTOR_GROUP = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_EXTRACTOR_GROUP", 'sameteam', true) >= 1
  })
end
function validatePlan19(team, time)
  return validate('fbkiln', {
    LACKS_1_VIRTUAL_CLASS_FACTORY_U = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_FACTORY_U", 'sameteam', true) < 1
   , HAS_1_VIRTUAL_CLASS_EXTRACTOR_GROUP = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_EXTRACTOR_GROUP", 'sameteam', true) >= 1
   , HAS_1_VIRTUAL_CLASS_FACTORY = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_FACTORY", 'sameteam', true) >= 1
  })
end
function validatePlan20(team, time)
  return validate('fvcons', {
    HAS_2_VIRTUAL_CLASS_EXTRACTOR_GROUP = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_EXTRACTOR_GROUP", 'sameteam', true) >= 2
  })
end
function validatePlan21(team, time)
  return validate('fbspir', {
    HAS_2_VIRTUAL_CLASS_EXTRACTOR_GROUP = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_EXTRACTOR_GROUP", 'sameteam', true) >= 2
  })
end
function validatePlan22(team, time)
  return validate('fvcons', {
    HAS_3_VIRTUAL_CLASS_EXTRACTOR_GROUP = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_EXTRACTOR_GROUP", 'sameteam', true) >= 3
  })
end
function validatePlan23(team, time)
  return validate('fbscav_c', {
    HAS_3_VIRTUAL_CLASS_EXTRACTOR_GROUP = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_EXTRACTOR_GROUP", 'sameteam', true) >= 3
   , HAS_2_VIRTUAL_CLASS_GUNTOWER = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_GUNTOWER", 'sameteam', true) >= 2
  })
end
function validatePlan24(team, time)
  return validate('fbdowe', {
    LACKS_1_VIRTUAL_CLASS_SUPPLYDEPOT = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_SUPPLYDEPOT", 'sameteam', true) < 1
   , HAS_2_VIRTUAL_CLASS_EXTRACTOR_GROUP = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_EXTRACTOR_GROUP", 'sameteam', true) >= 2
   , HAS_1_VIRTUAL_CLASS_FACTORY = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_FACTORY", 'sameteam', true) >= 1
  })
end
function validatePlan25(team, time)
  return validate('fbantm', {
    HAS_2_VIRTUAL_CLASS_EXTRACTOR_GROUP = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_EXTRACTOR_GROUP", 'sameteam', true) >= 2
   , HAS_1_VIRTUAL_CLASS_FACTORY = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_FACTORY", 'sameteam', true) >= 1
  })
end
function validatePlan26(team, time)
  return validate('fbspir', {
    HAS_2_VIRTUAL_CLASS_EXTRACTOR_GROUP = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_EXTRACTOR_GROUP", 'sameteam', true) >= 2
  })
end
function validatePlan27(team, time)
  return validate('fbstro', {
    HAS_3_VIRTUAL_CLASS_EXTRACTOR_GROUP = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_EXTRACTOR_GROUP", 'sameteam', true) >= 3
   , HAS_1_VIRTUAL_CLASS_FACTORY_U = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_FACTORY_U", 'sameteam', true) >= 1
  })
end
function validatePlan28(team, time)
  return validate('fbantm', {
    HAS_3_VIRTUAL_CLASS_EXTRACTOR_GROUP = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_EXTRACTOR_GROUP", 'sameteam', true) >= 3
   , HAS_1_VIRTUAL_CLASS_FACTORY_U = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_FACTORY_U", 'sameteam', true) >= 1
   , HAS_1_VIRTUAL_CLASS_ANTENNA_MOUND = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_ANTENNA_MOUND", 'sameteam', true) >= 1
  })
end
function validatePlan29(team, time)
  return validate('fbjamm', {
    HAS_1_VIRTUAL_CLASS_EXTRACTOR_GROUP = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_EXTRACTOR_GROUP", 'sameteam', true) >= 1
   , HAS_1_VIRTUAL_CLASS_OVERSEER_ARRAY = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_OVERSEER_ARRAY", 'sameteam', true) >= 1
  })
end
function validatePlan30(team, time)
  return validate('fbspir', {
    HAS_2_VIRTUAL_CLASS_EXTRACTOR_GROUP = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_EXTRACTOR_GROUP", 'sameteam', true) >= 2
  })
end
function validatePlan31(team, time)
  return validate('fbspir', {
    HAS_2_VIRTUAL_CLASS_EXTRACTOR_GROUP = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_EXTRACTOR_GROUP", 'sameteam', true) >= 2
  })
end
function validatePlan32(team, time)
  return validate('fbspir', {
    HAS_2_VIRTUAL_CLASS_EXTRACTOR_GROUP = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_EXTRACTOR_GROUP", 'sameteam', true) >= 2
  })
end
function validatePlan33(team, time)
  return validate('fvatank', {
    HAS_3_VIRTUAL_CLASS_EXTRACTOR_GROUP = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_EXTRACTOR_GROUP", 'sameteam', true) >= 3
   , HAS_1_VIRTUAL_CLASS_FACTORY_U = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_FACTORY_U", 'sameteam', true) >= 1
   , HAS_1_VIRTUAL_CLASS_OVERSEER_ARRAY = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_OVERSEER_ARRAY", 'sameteam', true) >= 1
   , HAS_1_VIRTUAL_CLASS_ARMORY = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_ARMORY", 'sameteam', true) >= 1
  })
end
function validatePlan34(team, time)
  return validate('fvwalk', {
    HAS_2_VIRTUAL_CLASS_EXTRACTOR_GROUP = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_EXTRACTOR_GROUP", 'sameteam', true) >= 2
   , HAS_1_VIRTUAL_CLASS_FACTORY_U = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_FACTORY_U", 'sameteam', true) >= 1
   , HAS_1_VIRTUAL_CLASS_SUPPLYDEPOT = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_SUPPLYDEPOT", 'sameteam', true) >= 1
   , HAS_1_VIRTUAL_CLASS_ARMORY = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_ARMORY", 'sameteam', true) >= 1
  })
end
function validatePlan35(team, time)
  return validate('fvartl', {
    HAS_2_VIRTUAL_CLASS_EXTRACTOR_GROUP = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_EXTRACTOR_GROUP", 'sameteam', true) >= 2
   , HAS_1_VIRTUAL_CLASS_FACTORY_U = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_FACTORY_U", 'sameteam', true) >= 1
   , HAS_1_VIRTUAL_CLASS_OVERSEER_ARRAY = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_OVERSEER_ARRAY", 'sameteam', true) >= 1
  })
end
function validatePlan36(team, time)
  return validate('fvtank', {
    HAS_1_VIRTUAL_CLASS_EXTRACTOR_GROUP = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_EXTRACTOR_GROUP", 'sameteam', true) >= 1
   , HAS_1_VIRTUAL_CLASS_FACTORY_U = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_FACTORY_U", 'sameteam', true) >= 1
   , HAS_1_VIRTUAL_CLASS_ANTENNA_MOUND = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_ANTENNA_MOUND", 'sameteam', true) >= 1
   , LACKS_1_VIRTUAL_CLASS_OVERSEER_ARRAY = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_OVERSEER_ARRAY", 'sameteam', true) < 1
  })
end
function validatePlan37(team, time)
  return validate('fvarch', {
    HAS_1_VIRTUAL_CLASS_EXTRACTOR_GROUP = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_EXTRACTOR_GROUP", 'sameteam', true) >= 1
   , HAS_1_VIRTUAL_CLASS_FACTORY = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_FACTORY", 'sameteam', true) >= 1
   , HAS_1_VIRTUAL_CLASS_ANTENNA_MOUND = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_ANTENNA_MOUND", 'sameteam', true) >= 1
  })
end
function validatePlan38(team, time)
  return validate('fvsent', {
    HAS_1_VIRTUAL_CLASS_EXTRACTOR_GROUP = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_EXTRACTOR_GROUP", 'sameteam', true) >= 1
   , HAS_1_VIRTUAL_CLASS_FACTORY = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_FACTORY", 'sameteam', true) >= 1
   , LACKS_1_VIRTUAL_CLASS_FACTORY_U = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_FACTORY_U", 'sameteam', true) < 1
  })
end
function validatePlan39(team, time)
  return validate('fvscout', {
    HAS_1_VIRTUAL_CLASS_EXTRACTOR_GROUP = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_EXTRACTOR_GROUP", 'sameteam', true) >= 1
   , LACKS_1_VIRTUAL_CLASS_FACTORY_U = AIPUtil.CountUnits(team, "VIRTUAL_CLASS_FACTORY_U", 'sameteam', true) < 1
  })
end
