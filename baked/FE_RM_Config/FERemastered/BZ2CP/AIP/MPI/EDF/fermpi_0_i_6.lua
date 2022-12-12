-- Strategy
-- recy
-- 3 scavs
-- u: scouts
-- POOLS 1
-- 1 cons
-- 1 power
-- cbun
-- 1 gtow
-- fact
-- u: scout, misl
-- POOLS 2
-- 2 power
-- 2 cons
-- armo
-- 2 gtow
-- sbay
-- upgrade pools
-- u: misl, tank, rckt, asslt
-- POOLS 3
-- 3 power
-- 3 gtow
-- train
-- 4 gtow
-- tcen
-- bomber
-- u: rckt, asslt, walker, apc





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
  return validate('ScavengerBuildLoopCondition', {
    no3scavs = CountCPUScavengers(team, time) < 3,
    poolsOrScrap = CanCollectScrapPool(team, time)
                or CanCollectLooseScrap(team, time),
    recyclerExists = DoesRecyclerExist(team, time)
  })
end

-- Condition for letting the CPU build Constructors.
function ConstructorBuildLoopCondition(team, time)
  return validate('ConstructorBuildLoopCondition', {
    has40Scrap = AIPUtil.GetScrap(team, true) >= 40,
    recyclerExists = DoesRecyclerExist(team, time),
    noConsExist = CountCPUConstructors(team, time) < 1
  })
end

-- Condition for letting the CPU build Turrets.
function TurretBuildLoopCondition(team, time)
  return validate('TurretBuildLoopCondition', {
    hasAPool = CountCPUExtractors(team, time) > 0,
    recyclerExists = DoesRecyclerExist(team, time)
  })
end

-- Condition for letting the CPU build Service Trucks.
function ServiceTruckBuildLoopCondition(team, time)
  return validate('ServiceTruckBuildLoopCondition', {
    has2Pool = CountCPUExtractors(team, time) > 1,
    recyclerExists = DoesRecyclerExist(team, time),
    serviceBayExists = DoesServiceBayExist(team, time)
  })
end

-- Condition for letting the CPU build Gun Tower Constructors.
function GunTowerConstructorBuildLoopCondition(team, time)
  return validate('GunTowerConstructorBuildLoopCondition', {
    scrapOver40 = AIPUtil.GetScrap(team, true) >= 40,
    recyclerExists = DoesRecyclerExist(team, time)
  })
end

-- Condition for letting the CPU build a Bomber.
function BomberBuildLoopCondition(team, time)
  return validate('BomberBuildLoopCondition', {
    scrapOver75 = AIPUtil.GetScrap(team, true) >= 75,
    bomberBayExists = DoesBomberBayExist(team, time),
    noBomberExists = not DoesBomberExist(team, time)
  })
end

----------------
-- Building Checks
----------------

-- Allow the CPU to build a Gun Tower on the gtow1 path.
function BuildForwardGunTower1(team, time)
  return validate('BuildGunTower', {
    noGunTowersExist = CountCPUGunTowers(team, true) < 1,
    haveOnePool = CountCPUExtractors(team, true) > 0,
    powerNotZero = AIPUtil.GetPower(team, true) > 0,
    cbunExists = DoesCommBunkerExist(team, time)
  })
end

-- Allow the CPU to build a Power Generator
function BuildPowerGenerator(team, time)
  return validate('BuildPowerGenerator', {
    scrapOver30 = AIPUtil.GetScrap(team, true) >= 30,
    consNotZero = CountCPUConstructors(team, time) > 0,
    powerUnder1 = AIPUtil.GetPower(team, true) <= 0
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

-- How many pools does the AI have
function CountCPUExtractors(team, time)
    return AIPUtil.CountUnits(team, "VIRTUAL_CLASS_EXTRACTOR_Group", 'sameteam', true);
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

-- Check if the player has any Gun Towers.
function CountCPUGunTowers(team, time)
    return AIPUtil.CountUnits(team, "VIRTUAL_CLASS_GUNTOWER", 'sameteam', true);
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
    consExists = CountCPUConstructors(team, time) >= 1,
    extractor1Exists = CountCPUExtractors(team, time) >= 1
  })
end

-- All the CPU to upgrade their second Extractor.
function UpgradeSecondExtractor(team, time)
  return validate('UpgradeSecondExtractor', {
    scrapOver60 = AIPUtil.GetScrap(team, true) >= 60,
    consExists = CountCPUConstructors(team, time) >= 1,
    extractor2Exists = CountCPUExtractors(team, time) >= 2
  })
end

-- All the CPU to upgrade their third Extractor.
function UpgradeThirdExtractor(team, time)
  return validate('UpgradeThirdExtractor', {
    scrapOver60 = AIPUtil.GetScrap(team, true) >= 60,
    consExists = CountCPUConstructors(team, time) >= 1,
    extractor3Exists = CountCPUExtractors(team, time) >= 3
  })
end

-- All the CPU to upgrade their fourth Extractor.
function UpgradeFourthExtractor(team, time)
  return validate('UpgradeFourthExtractor', {
    scrapOver60 = AIPUtil.GetScrap(team, true) >= 60,
    consExists = CountCPUConstructors(team, time) >= 1,
    extractor4Exists = CountCPUExtractors(team, time) >= 4
  })
end

----------------
-- Attack Checks
----------------

-- Send Scouts to attack enemy Pools if we don't have enough.
function SendExtractorAttacks(team, time)
  return validate('SendExtractorAttacks', {
    no3Extractors = CountCPUExtractors(team, time) < 3
  })
end

-- Allow for early game harassment by the AI.
function SendEarlyScoutHarassment(team, time)
  return validate('SendEarlyScoutHarassment', {
    factoryExists = DoesFactoryExist(team, time)
  })
end

-- Allow for harassment after the Factory has been built.
function SendMediumHarassment(team, time)
  return validate('SendMediumHarassment', {
    factoryExists = DoesFactoryExist(team, time)
  })
end

-- Allow for harassment after the factory and armory has been built by the AI.
function SendArtilleryHarassment(team, time)
  return validate('SendArtilleryHarassment', {
    factoryExists = DoesFactoryExist(team, time),
    armoryExists = DoesArmoryExist(team, time)
  })
end

-- Allow for harassment after the necessary required buildings has been built by the AI.
function SendAssaultHarassment(team, time)
  return validate('SendAssaultHarassment', {
    factoryExists = DoesFactoryExist(team, time),
    armoryOrSbayExists = DoesArmoryExist(team, time)
                      or DoesServiceBayExist(team, time),
    commBunkerExists = DoesCommBunkerExist(team, time)
  })
end

-- Allow for harassment after the necessary required buldings has been built by the AI.
function SendTankHarassment(team, time)
  return validate('SendTankHarassment', {
    factoryExists = DoesFactoryExist(team, time),
    commBunkerExists = DoesCommBunkerExist(team, time)
  })
end

-- Anti Gun Tower attack.
function SendGunTowerAttacks(team, time)
  return validate('SendGunTowerAttacks', {
    tanksorAssaultorAir = SendTankHarassment(team, time)
                       or SendAssaultHarassment(team, time)
                       or SendAPCAttacks(team, time),
    humanHasGunTowers = DoesHumanHaveGunTowers(team, time)
  })
end

-- APC attack.
function SendAPCAttacks(team, time)
  return validate('SendAPCAttacks', {
    factoryExists = DoesFactoryExist(team, time),
    trainingCenterExists = DoesTrainingCenterExist(team, time)
  })
end

-- Bomber attack.
function SendBomberAttacks(team, time)
  return validate('SendBomberAttacks', {
    bomberExists = DoesBomberExist(team, time)
  })
end

-- Technical attack.
function SendTechnicalAttacks(team, time)
  return validate('SendTechnicalAttacks', {
    factoryExists = DoesFactoryExist(team, time),
    doesTechCenterExist = DoesTechCenterExist(team, time)
  })
end