-- File: fercpu_i0.lua
-- Author(s): AI_Unit
-- Summary: Lua conditions for the EDF easy AIP.

-- Initiate AIP Lua Conditions.
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

----------------
-- Map Checks
----------------

-- Check if any vacant pools exist on the map.
function DoesVacantScrapPoolExist(team, time)
    return AIPUtil.CountUnits(team, "biometal", "friendly", true) > 0;
end

-- Check if any scrap exists on the map.
function DoesLooseScrapExist(team, time)
    return AIPUtil.CountUnits(team, "resource", "friendly", true) > 0;
end

----------------
-- Unit Checks
----------------

-- Condition for letting the CPU build Scavengers.
function ScavengerBuildLoopCondition(team, time)
    -- Get my scrap in a local variable.
    local myScrap = AIPUtil.GetScrap(team, true);

    -- Check if any pools exist that are currently unclaimed.
    local poolsToClaim = CanCollectScrapPool(team, time);

    -- Check if any loose scrap exists on the map.
    local looseScrapToClaim = CanCollectLooseScrap(team, time);

    -- Keep track of the count of Scavengers we already have to stop overbuilding.
    local cpuScavCount = CountCPUScavengers(team, time);

    -- If the conditions above are true, let the AIP build a Scavenger for pools/scrap.
    if (myScrap >= 20 and (poolsToClaim or looseScrapToClaim) and cpuScavCount < 3) then
        return true, "ScavengerBuildLoopCondition: Conditions met. Proceeding...";
    else
        return false, "ScavengerBuildLoopCondition: Conditions unmet. Halting plan.";
    end
end

-- Condition for letting the CPU build Constructors.
function ConstructorBuildLoopCondition(team, time)
    -- Get my scrap in a local variable.
    local myScrap = AIPUtil.GetScrap(team, true);

    -- Does the Recycler exist?
    local recyclerExists = DoesRecyclerExist(team, time);

    -- Keep track of the count of Scavengers we already have to stop overbuilding.
    local cpuConsCount = CountCPUConstructors(team, time);

    -- If the conditions above are true, let the AIP build a Constructor.
    if (myScrap >= 40 and recyclerExists and cpuConsCount < 1) then
        return true, "ConstructorBuildLoopCondition: Conditions met. Proceeding...";
    else
        return false, "ConstructorBuildLoopCondition: Conditions unmet. Halting plan.";
    end
end

-- Condition for letting the CPU build Turrets.
function TurretBuildLoopCondition(team, time)
    -- Get my scrap in a local variable.
    local myScrap = AIPUtil.GetScrap(team, true);

    -- Does the Recycler exist?
    local recyclerExists = DoesRecyclerExist(team, time);

    -- If the conditions above are true, let the AIP build a Turret.
    if (myScrap >= 40 and recyclerExists) then
        return true, "TurretBuildLoopCondition: Conditions met. Proceeding...";
    else
        return false, "TurretBuildLoopCondition: Conditions unmet. Halting plan.";
    end
end

-- Condition for letting the CPU build Service Trucks.
function ServiceTruckBuildLoopCondition(team, time)
    -- Get my scrap in a local variable.
    local myScrap = AIPUtil.GetScrap(team, true);

    -- Does the Recycler exist?
    local recyclerExists = DoesRecyclerExist(team, time);

    -- Does the Service Bay exist?
    local serviceBayExists = DoesServiceBayExist(team, time);

    -- If the conditions above are true, let the AIP build a Turret.
    if (myScrap >= 50 and recyclerExists and serviceBayExists) then
        return true, "ServiceTruckBuildLoopCondition: Conditions met. Proceeding...";
    else
        return false, "ServiceTruckBuildLoopCondition: Conditions unmet. Halting plan.";
    end
end

-- Condition for letting the CPU build Gun Tower Constructors.
function GunTowerConstructorBuildLoopCondition(team, time)
    -- Get my scrap in a local variable.
    local myScrap = AIPUtil.GetScrap(team, true);

    -- Does the Recycler exist?
    local recyclerExists = DoesRecyclerExist(team, time);

    -- If the conditions above are true, let the AIP build a Constructor.
    if (myScrap >= 40 and recyclerExists) then
        return true, "GunTowerConstructorBuildLoopCondition: Conditions met. Proceeding...";
    else
        return false, "GunTowerConstructorBuildLoopCondition: Conditions unmet. Halting plan.";
    end
end

-- Condition for letting the CPU build a Bomber.
function BomberBuildLoopCondition(team, time)
    -- Get my scrap in a local variable.
    local myScrap = AIPUtil.GetScrap(team, true);

    -- Does the Recycler exist?
    local factoryExists = DoesFactoryExist(team, time);

    -- Does the Bomber Bay exist?
    local bomberBayExists = DoesBomberBayExist(team, time);

    -- Does a Bomber already exist?
    local bomberExists = DoesBomberExist(team, time);

    -- If the conditions above are true, let the AIP build a Turret.
    if (myScrap >= 75 and factoryExists and bomberBayExists and not bomberExists) then
        return true, "BomberBuildLoopCondition: Conditions met. Proceeding...";
    else
        return false, "BomberBuildLoopCondition: Conditions unmet. Halting plan.";
    end
end

----------------
-- Building Checks
----------------

-- Allow the CPU to build a Gun Tower on the gtow1 path.
function BuildGunTower(team, time)
  return validate('BuildGunTower', {
    scrapOver50 = AIPUtil.GetScrap(team, true) >= 50
  })
end

-- Allow the CPU to build a Power Generator
function BuildPowerGenerator(team, time)
  return validate('BuildPowerGenerator', {
    scrapOver30 = AIPUtil.GetScrap(team, true) >= 30,
    consNotZero = CountCPUConstructors(team, time) > 0,
    powerLEZero = AIPUtil.GetPower(team, true) <= 0
  })
end

function BuildFactory(team, time)
  return validate('BuildFactory', {
    scrapOver55 = AIPUtil.GetScrap(team, true) >= 55,
    consNotZero = CountCPUConstructors(team, time) > 0,
    powerNotZero = AIPUtil.GetPower(team, true) > 0,
    notAlreadyUp = not DoesFactoryExist(team, time)
  })
end

-- Allow the CPU to build an Armory.
function BuildArmory(team, time)
  return validate('BuildArmory', {
    scrapOver60 = AIPUtil.GetScrap(team, true) >= 60,
    consNotZero = CountCPUConstructors(team, time) > 0,
    powerNotZero = AIPUtil.GetPower(team, true) > 0,
    notAlreadyUp = not DoesArmoryExist(team, time)
  })
end

-- Allow the CPU to build a Comm Bunker.
function BuildCommBunker(team, time)
  return validate('BuildCommBunker', {
    scrapOver50 = AIPUtil.GetScrap(team, true) >= 50,
    consNotZero = CountCPUConstructors(team, time) > 0,
    powerNotZero = AIPUtil.GetPower(team, true) > 0,
    notAlreadyUp = not DoesCommBunkerExist(team, time)
  })
end

-- Allow the CPU to build a Service Bay
function BuildServiceBay(team, time)
  return validate('BuildServiceBay', {
    scrapOver50 = AIPUtil.GetScrap(team, true) >= 50,
    consNotZero = CountCPUConstructors(team, time) > 0,
    powerNotZero = AIPUtil.GetPower(team, true) > 0,
    notAlreadyUp = not DoesServiceBayExist(team, time)
  })
end

-- Allow the CPU to build a Training Center
function BuildTraningCenter(team, time)
  return validate('BuildTraningCenter', {
    scrapOver70 = AIPUtil.GetScrap(team, true) >= 70,
    consNotZero = CountCPUConstructors(team, time) > 0,
    powerNotZero = AIPUtil.GetPower(team, true) > 0,
    notAlreadyUp = not DoesTrainingCenterExist(team, time)
  })
end

-- Allow the CPU to build a Tech Center.
function BuildTechCenter(team, time)
  return validate('BuildTechCenter', {
    scrapOver80 = AIPUtil.GetScrap(team, true) >= 80,
    consNotZero = CountCPUConstructors(team, time) > 0,
    powerNotZero = AIPUtil.GetPower(team, true) > 0,
    notAlreadyUp = not DoesTechCenterExist(team, time)
  })
end

-- Allow the CPU to build a Bomber Bay
function BuildBomberBay(team, time)
  return validate('BuildBomberBay', {
    scrapOver100 = AIPUtil.GetScrap(team, true) >= 100,
    consNotZero = CountCPUConstructors(team, time) > 0,
    powerNotZero = AIPUtil.GetPower(team, true) > 0,
    notAlreadyUp = not DoesBomberBayExist(team, time)
  })
end

-- Allow the CPU to build a Gun Tower at base
function BuildBaseGunTower(team, time)
  return validate('BuildBaseGunTower', {
    scrapOver50 = AIPUtil.GetScrap(team, true) >= 50,
    consNotZero = CountCPUConstructors(team, time) > 0,
    powerNotZero = AIPUtil.GetPower(team, true) > 0,
    cbunExists = DoesCommBunkerExist(team, time)
  })
end

----------------
-- Exist Checks
----------------

-- Condition for trying to collect pools.
function CanCollectScrapPool(team, time)
  return validate('CanCollectScrapPool', {
    recyExists = DoesRecyclerExist(team, time),
    vacantPoolExists = DoesVacantScrapPoolExist(team, time)
  })
end

-- Condition for trying to collect scrap.
function CanCollectLooseScrap(team, time)
  return validate('CanCollectLooseScrap', {
    recyExists = DoesRecyclerExist(team, time),
    looseExists = DoesLooseScrapExist(team, time)
  })
end

-- Checks if the Recycler exists.
function DoesRecyclerExist(team, time)
    return AIPUtil.CountUnits(team, "VIRTUAL_CLASS_RECYCLERBUILDING", 'sameteam', true) > 0;
end

-- Checks if the Factory exists.
function DoesFactoryExist(team, time)
    return AIPUtil.CountUnits(team, "VIRTUAL_CLASS_FACTORY", 'sameteam', true) > 0;
end

-- Checks if the Armory exists.
function DoesArmoryExist(team, time)
    return AIPUtil.CountUnits(team, "VIRTUAL_CLASS_ARMORY", 'sameteam', true) > 0;
end

-- Checks if the Service Bay exists.
function DoesServiceBayExist(team, time)
    return AIPUtil.CountUnits(team, "VIRTUAL_CLASS_SUPPLYDEPOT", 'sameteam', true) > 0;
end

-- Checks if a Comm Bunker exists.
function DoesCommBunkerExist(team, time)
    return AIPUtil.CountUnits(team, "VIRTUAL_CLASS_COMMBUNKER", 'sameteam', true) > 0;
end

-- Checks if the Training Center exists.
function DoesTrainingCenterExist(team, time)
    return AIPUtil.CountUnits(team, "VIRTUAL_CLASS_BARRACKS", 'sameteam', true) > 0;
end

-- Checks if the Tech Center exists.
function DoesTechCenterExist(team, time)
    return AIPUtil.CountUnits(team, "VIRTUAL_CLASS_TECHCENTER", 'sameteam', true) > 0;
end

-- Checks if the Bomber Bay exists.
function DoesBomberBayExist(team, time)
    return AIPUtil.CountUnits(team, "VIRTUAL_CLASS_BOMBERBAY", 'sameteam', true) > 0;
end

-- Checks if the Bomber exists.
function DoesBomberExist(team, time)
    return AIPUtil.CountUnits(team, "VIRTUAL_CLASS_BOMBER", 'sameteam', true) > 0;
end

----------------
-- Counts
----------------

-- Checks how many Scavengers the CPU has.
function CountCPUScavengers(team, time)
    return AIPUtil.CountUnits(team, "VIRTUAL_CLASS_SCAVENGER", 'sameteam', true);
end

-- Checks how many Constructors the CPU has.
function CountCPUConstructors(team, time)
    return AIPUtil.CountUnits(team, "VIRTUAL_CLASS_CONSTRUCTIONRIG", 'sameteam', true);
end

-- Checks how many Extractors the CPU has.
function CountCPUExtractors(team, time)
    return AIPUtil.CountUnits(team, "VIRTUAL_CLASS_EXTRACTOR", 'sameteam', true);
end

-- Checks how many upgraded Extractors the CPU has.
function CountCPUUpgradedExtractors(team, time)
    return AIPUtil.CountUnits(team, "VIRTUAL_CLASS_EXTRACTOR_Upgraded", 'sameteam', true);
end

-- Returns the amount of power the CPU has available.
function CountCPUPower(team, time)
    return AIPUtil.GetPower(team, false);
end

----------------
-- Human Checks
----------------

-- Check if the player has any Gun Towers.
function DoesHumanHaveGunTowers(team, time)
    return AIPUtil.CountUnits(1, "VIRTUAL_CLASS_GUNTOWER", 'sameteam', true) > 0;
end

----------------
-- Upgrade Checks
----------------

-- Allow the CPU to upgrade their first Extractor.
function UpgradeFirstExtractor(team, time)
  return validate('UpgradeFirstExtractor', {
    scrapOver60 = AIPUtil.GetScrap(team, true) >= 60,
    cons1Exists = CountCPUConstructors(team, time) >= 1,
    extractor1Exists = CountCPUExtractors(team, time) >= 1
  })
end

-- All the CPU to upgrade their second Extractor.
function UpgradeSecondExtractor(team, time)
  return validate('UpgradeFirstExtractor', {
    scrapOver60 = AIPUtil.GetScrap(team, true) >= 60,
    cons1Exists = CountCPUConstructors(team, time) >= 1,
    extractor2Exists = CountCPUExtractors(team, time) >= 2
  })
end

-- All the CPU to upgrade their third Extractor.
function UpgradeThirdExtractor(team, time)
  return validate('UpgradeFirstExtractor', {
    scrapOver60 = AIPUtil.GetScrap(team, true) >= 60,
    cons1Exists = CountCPUConstructors(team, time) >= 1,
    extractor3Exists = CountCPUExtractors(team, time) >= 3
  })
end

-- All the CPU to upgrade their fourth Extractor.
function UpgradeFourthExtractor(team, time)
  return validate('UpgradeFirstExtractor', {
    scrapOver60 = AIPUtil.GetScrap(team, true) >= 60,
    cons1Exists = CountCPUConstructors(team, time) >= 1,
    extractor4Exists = CountCPUExtractors(team, time) >= 4
  })
end

----------------
-- Attack Checks
----------------

-- Send Scouts to attack enemy Pools if we don't have enough.
function SendExtractorAttacks(team, time)
    -- Count CPU extractors.
    local cpuExtractorCount = CountCPUExtractors(team, time);

    -- Allow this attack if all of these conditions are met.
    if (cpuExtractorCount < 3) then
        return true, "SendExtractorAttacks: Conditions met. Proceeding...";
    else 
        return false, "SendExtractorAttacks: Conditions unmet. Halting plan. Time is " .. time;
    end
end

-- Allow for early game harassment by the AI.
function SendEarlyScoutHarassment(team, time)
    -- Check if Factory exists.
    local factoryExists = DoesFactoryExist(team, time);

    -- Allow this attack if all of these conditions are met.
    if (not factoryExists) then
        return true, "SendEarlyScoutHarassment: Conditions met. Proceeding...";
    else 
        return false, "SendEarlyScoutHarassment: Conditions unmet. Halting plan. Time is " .. time;
    end
end

-- Allow for harassment after the Factory has been built.
function SendMediumHarassment(team, time)
    -- Check if Factory exists.
    local factoryExists = DoesFactoryExist(team, time);
    
    -- Allow this attack if all of these conditions are met.
    if (factoryExists) then
        return true, "SendMediumHarassment: Conditions met. Proceeding...";
    else 
        return false, "SendMediumHarassment: Conditions unmet. Halting plan. Time is " .. time;
    end
end

-- Allow for harassment after the factory and armory has been built by the AI.
function SendArtilleryHarassment(team, time)
    -- Check if Factory exists.
    local factoryExists = DoesFactoryExist(team, time);
    
    -- Check if Armory exists.
    local armoryExists = DoesArmoryExist(team, time);

    -- Allow this attack if all of these conditions are met.
    if (factoryExists and armoryExists) then
        return true, "SendArtilleryHarassment: Conditions met. Proceeding...";
    else 
        return false, "SendArtilleryHarassment: Conditions unmet. Halting plan. Time is " .. time;
    end
end

-- Allow for harassment after the necessary required buildings has been built by the AI.
function SendAssaultHarassment(team, time)
    -- Check if Factory exists.
    local factoryExists = DoesFactoryExist(team, time);
    
    -- Check if Armory exists.
    local armoryExists = DoesArmoryExist(team, time);

    -- Check if the Service Bay exists.
    local serviceBayExists = DoesServiceBayExist(team, time);

    -- Check if the Comm Bunker exists.
    local commBunkerExists = DoesCommBunkerExist(team, time);

    -- Allow this attack if all of these conditions are met.
    if (factoryExists and (armoryExists or serviceBayExists) and commBunkerExists) then
        return true, "SendAssaultHarassment: Conditions met. Proceeding...";
    else 
        return false, "SendAssaultHarassment: Conditions unmet. Halting plan. Time is " .. time;
    end
end

-- Allow for harassment after the necessary required buldings has been built by the AI.
function SendTankHarassment(team, time)
    -- Check if Factory exists.
    local factoryExists = DoesFactoryExist(team, time);

    -- Check if the Comm Bunker exists.
    local commBunkerExists = DoesCommBunkerExist(team, time);

    -- Allow this attack if all of these conditions are met.
    if (factoryExists and commBunkerExists) then
        return true, "SendTankHarassment: Conditions met. Proceeding...";
    else 
        return false, "SendTankHarassment: Conditions unmet. Halting plan. Time is " .. time;
    end
end

-- Anti Gun Tower attack.
function SendGunTowerAttacks(team, time)
    -- Check if any of the following conditions are met before trying to attack Gun Towers.
    local tanksAvailable = SendTankHarassment(team, time);
    local assaultAvailable = SendAssaultHarassment(team, time);
    local airAvailable = SendAPCAttacks(team, time);

    -- Check if the human team has any Gun Towers.
    local humanHasGunTowers = DoesHumanHaveGunTowers(team, time);

    -- Allow this attack if all of these conditions are met.
    if ((tanksAvailable or assaultAvailable or airAvailable) and humanHasGunTowers) then
        return true, "SendGunTowerAttacks: Conditions met. Proceeding...";
    else 
        return false, "SendGunTowerAttacks: Conditions unmet. Halting plan. Time is " .. time;
    end
end

-- APC attack.
function SendAPCAttacks(team, time)
    -- Check if Factory exists.
    local factoryExists = DoesFactoryExist(team, time);

    -- Check if the Training Center exists.
    local trainingCenterExists = DoesTrainingCenterExist(team, time);

    -- Allow this attack if all of these conditions are met.
    if (factoryExists and trainingCenterExists) then
        return true, "SendAPCAttacks: Conditions met. Proceeding...";
    else 
        return false, "SendAPCAttacks: Conditions unmet. Halting plan. Time is " .. time;
    end
end

-- Bomber attack.
function SendBomberAttacks(team, time)
    -- Check if the Bomber exists.
    local bomberExists = DoesBomberExist(team, time);

    -- Allow this attack if all of these conditions are met.
    if (bomberExists) then
        return true, "SendBomberAttacks: Conditions met. Proceeding...";
    else 
        return false, "SendBomberAttacks: Conditions unmet. Halting plan. Time is " .. time;
    end
end

-- Technical attack.
function SendTechnicalAttacks(team, time)
    -- Check if Factory exists.
    local factoryExists = DoesFactoryExist(team, time);

    -- Check if the Training Center exists.
    local doesTechCenterExist = DoesTechCenterExist(team, time);

    -- Allow this attack if all of these conditions are met.
    if (factoryExists and doesTechCenterExist) then
        return true, "SendTechnicalAttacks: Conditions met. Proceeding...";
    else 
        return false, "SendTechnicalAttacks: Conditions unmet. Halting plan. Time is " .. time;
    end
end