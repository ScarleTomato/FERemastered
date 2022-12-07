-- Scion strategy
-- recy
-- 3 scav
-- POOL 1
-- cons
-- turret
-- kiln
-- u: scout, sentry
-- POOL 2
-- 1 spire
-- forge
-- u: sentry, lancer, warrior
-- antenna
-- dower
-- 2 spire
-- stronghold
-- u: mauler
-- overseer
-- u: archer, brawler
-- jammer
-- upgrade pools
-- 3 spire
-- 4 spire
-- POOL 3

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
-- CPU Checks
----------------

-- Condition for letting the CPU build Scavengers.
function ScavengerBuildLoopCondition(team, time)
  return validate('ScavengerBuildLoopCondition', {
    poolsOrScrapToClaim = CanCollectScrapPool(team, time)
                       or CanCollectLooseScrap(team, time),
    no3ScavExist = CountCPUScavengers(team, time) < 3
  })
end

-- Condition for letting the CPU build Constructors.
function ConstructorBuildLoopCondition(team, time)
  return validate('ConstructorBuildLoopCondition', {
    scrapOver40 = AIPUtil.GetScrap(team, true) >= 40,
    recyclerExists = DoesRecyclerExist(team, time),
    no3ConsExist = CountCPUConstructors(team, time) < 3
  })
end

-- Condition for letting the CPU build Turrets.
function TurretBuildLoopCondition(team, time)
  return validate('TurretBuildLoopCondition', {
    scrapOver40 = AIPUtil.GetScrap(team, true) >= 40,
    recyclerExists = DoesRecyclerExist(team, time)
  })
end

----------------
-- Building Checks
----------------

-- Allow the CPU to build a Kiln.
function BuildKiln(team, time)
  return validate('BuildKiln', {
    scrapOver60 = AIPUtil.GetScrap(team, true) >= 60,
    consExists = CountCPUConstructors(team, time) > 0,
    noKilnExists = not DoesKilnExist(team, time)
  })
end

-- Allow the CPU to build a Dower.
function BuildDower(team, time)
  return validate('BuildDower', {
    scrapOver60 = AIPUtil.GetScrap(team, true) >= 60,
    consExists = CountCPUConstructors(team, time) > 0,
    kilnExists = DoesKilnExist(team, time),
    noDowerExists = not DoesDowerExist(team, time)
  })
end

-- Allow the CPU to build a Dower.
function BuildAntenna(team, time)
  return validate('BuildAntenna', {
    scrapOver60 = AIPUtil.GetScrap(team, true) >= 60,
    consExists = CountCPUConstructors(team, time) > 0,
    kilnExists = DoesKilnExist(team, time),
    noAntExists = not DoesAntennaExist(team, time)
  })
end

-- Allow the CPU to build a Dower.
function BuildStronghold(team, time)
  return validate('BuildStronghold', {
    scrapOver70 = AIPUtil.GetScrap(team, true) >= 70,
    consExists = CountCPUConstructors(team, time) > 0,
    forgeExists = DoesForgeExist(team, time),
    noStroExists = not DoesStrongholdExist(team, time)
  })
end

-- Allow the CPU to build a Gun Spire at base
function BuildBaseGunSpire(team, time)
  return validate('BuildBaseGunSpire', {
    scrapOver75 = AIPUtil.GetScrap(team, true) >= 75,
    consExists = CountCPUConstructors(team, time) > 0
  })
end

-- Allow the CPU to build a Gun Spire on the gtow1 path.
function BuildGunSpire1(team, time)
  return validate('BuildGunSpire1', {
    scrapOver75 = AIPUtil.GetScrap(team, true) >= 75,
    gtow1Exists = AIPUtil.PathExists("gtow1")
  })
end

-- Allow the CPU to build a Gun Spire on the gtow1 path.
function BuildGunSpire2(team, time)
  return validate('BuildGunSpire2', {
    scrapOver75 = AIPUtil.GetScrap(team, true) >= 75,
    gtow2Exists = AIPUtil.PathExists("gtow2")
  })
end

-- Allow the CPU to build a Gun Spire on the gtow1 path.
function BuildJammer(team, time)
  return validate('BuildJammer', {
    scrapOver50 = AIPUtil.GetScrap(team, true) >= 50,
    consExists = CountCPUConstructors(team, time) > 0,
    overseerExists = DoesOverseerExist(team, time)
  })
end

----------------
-- Exist Checks
----------------

-- Condition for trying to collect pools.
function CanCollectScrapPool(team, time)
  return validate('CanCollectScrapPool', {
    recyExists = DoesRecyclerExist(team, time),
    vacantPoolExists =  DoesVacantScrapPoolExist(team, time)
  })
end

-- Condition for trying to collect scrap.
function CanCollectLooseScrap(team, time)
  return validate('CanCollectLooseScrap', {
    recyExists = DoesRecyclerExist(team, time),
    looseScrapExist =  DoesLooseScrapExist(team, time)
  })
end

-- Checks if the Recycler exists.
function DoesRecyclerExist(team, time)
    return AIPUtil.CountUnits(team, "VIRTUAL_CLASS_RECYCLERBUILDING", 'sameteam', true) > 0;
end

-- Checks if the Kiln exists.
function DoesKilnExist(team, time)
    return AIPUtil.CountUnits(team, "VIRTUAL_CLASS_FACTORY", 'sameteam', true) > 0;
end

-- Checks if the Forge exists.
function DoesForgeExist(team, time)
    return AIPUtil.CountUnits(team, "VIRTUAL_CLASS_FACTORY_U", 'sameteam', true) > 0;
end

-- Checks if the Forge exists.
function DoesDowerExist(team, time)
    return AIPUtil.CountUnits(team, "VIRTUAL_CLASS_SUPPLYDEPOT", 'sameteam', true) > 0;
end

-- Checks if the Antenna exists.
function DoesAntennaExist(team, time)
    return AIPUtil.CountUnits(team, "VIRTUAL_CLASS_COMMBUNKER", 'sameteam', true) > 0;
end

-- Checks if the Antenna exists.
function DoesOverseerExist(team, time)
    return AIPUtil.CountUnits(team, "VIRTUAL_CLASS_COMMBUNKER_U", 'sameteam', true) > 0;
end

-- Checks if the Stronghold exists.
function DoesStrongholdExist(team, time)
    return AIPUtil.CountUnits(team, "VIRTUAL_CLASS_ARMORY", 'sameteam', true) > 0;
end

----------------
-- Counts
----------------

-- Checks how many Scavengers the CPU has.
function CountCPUScavengers(team, time)
    return AIPUtil.CountUnits(team, "VIRTUAL_CLASS_SCAVENGER", 'sameteam', true);
end

-- How many pools does the AI have
function CountCPUExtractors(team, time)
    return AIPUtil.CountUnits(team, "VIRTUAL_CLASS_EXTRACTOR_GROUP", 'sameteam', true);
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

-- Checks how many Gun Spires the CPU has.
function CountCPUGunSpires(team, time)
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
function UpgradeKiln(team, time)
  return validate('UpgradeKiln', {
    scrapOver60 = AIPUtil.GetScrap(team, true) >= 60,
    consExists = CountCPUConstructors(team, time) >= 1,
    doesKilnExist = DoesKilnExist(team, time),
    gunSpire2Exists = CountCPUGunSpires(team, time) >= 2
  })
end

-- Allow the CPU to upgrade their antenna.
function UpgradeAntenna(team, time)
  return validate('UpgradeAntenna', {
    scrapOver80 = AIPUtil.GetScrap(team, true) >= 80,
    consExists = CountCPUConstructors(team, time) >= 1,
    doesAntExist = DoesAntennaExist(team, time)
  })
end

-- Allow the CPU to upgrade their first Extractor.
function UpgradeFirstExtractor(team, time)
  return validate('UpgradeFirstExtractor', {
    scrapOver60 = AIPUtil.GetScrap(team, true) >= 60,
    consExists = CountCPUConstructors(team, time) >= 1,
    extractorExists = CountCPUExtractors(team, time) >= 1
  })
end

----------------
-- Attack Checks
----------------

-- Send Scouts to attack enemy Pools if we don't have enough.
function SendExtractorAttacks(team, time)
  return validate('SendExtractorAttacks', {
    noThirdExtractor = CountCPUExtractors(team, time) < 3
  })
end

-- Allow for early game harassment by the AI.
function SendEarlyScoutHarassment(team, time)
  return validate('SendEarlyScoutHarassment', {
    kilnExists = DoesKilnExist(team, time),
    noForgeExists = not DoesForgeExist(team, time)
  })
end

-- Allow for harassment after the Factory has been built.
function SendMediumHarassment(team, time)
  return validate('SendMediumHarassment', {
    forgeExists = DoesForgeExist(team, time)
  })
end