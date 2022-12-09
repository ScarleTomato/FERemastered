import io, os, oyaml as yaml

def start(race, team): return [ '[Start]', 'idleAllCraft = false', f'scavClass = "{race}vscav_c"', f'consClass = "{race}vcons"', 'CheckProvides = true', 'DLLCanSwitch = true', 'baseDir = 2', f'baseLoc = "Recycler_{team}"', 'UnitsService = true', 'Difficulty = 1', '']
cheat = ['[Cheat]', 'moneyAmount = 3', 'moneyDelay = 5', '']
dispatch = ['[IdleDispatcher]' , 'ScavIdleSeconds = 5' , 'UnitIdleSeconds = 45' , 'BomberIdleSeconds = 75' , 'CraftTeamIsPilotTeam = true' , 'MaxPatrolUnits = 3' , 'MaxHuntUnits = 2' , 'MaxEscortUnits = 4' , '']
luaStart = """
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
"""

def writeLines(lines:list, fn:str):
  print(f'writing to {fn}')
  with open(fn, 'w') as f:
    for line in lines:
      f.write(line + '\n')

def fromYamlFile(path):
  print(f'Reading {os.path.basename(path)}')
  with open(path, 'r') as fin:
    return yaml.load(fin, Loader=yaml.Loader)

def yamlToLines(yml, race, team):
  scavnoidle = yml['global'].get('scavnoidle') or False
  consnoidle = yml['global'].get('consnoidle') or False
  # preplans: server, recover, scavs, pool, pool, field, cons
  planCount = 1
  planPriority = (len(yml['plans']) + 7) * 10
  lines = start(race, team)
  lines.extend(cheat)
  lines.extend(dispatch)
  luaLines = [luaStart]
  for plan in yml['plans']:
    lines.append(f'[Plan{planCount}]')
    if 'build' in plan:
      lines.append(f'planType = "{"Base" if "b" == plan["build"][1] else ""}BuildMinimums"')
      lines.append(f'planPriority = {planPriority}')
      lines.append(f'buildType1 = "{plan["build"]}"')
      lines.append(f'buildCount1 = {plan.get("amt", 1)}')
      if 'b' == plan['build'][1]:
        lines.append(f'buildLoc1 = "{plan["at"]}_{team}"')
        lines.append(f'ContinueEvenIfFail = true')
        lines.append(f'buildIfNoIdle = {consnoidle}')
    elif 'upgrade' in plan:
      lines.append('planType = "Upgrade"')
      lines.append(f'planPriority = {planPriority}')
      lines.append(f'unitType ="{plan["upgrade"]}"')
    elif 'service' in plan:
      lines.append(f'planType = "{"Service" if "v" == plan["service"][1] else "Recover"}"')
      lines.append(f'planPriority = {planPriority}')
      lines.append(f'serviceUnit = "{plan["service"]}"')
      for i, unit in enumerate(plan['units']):
        lines.append(f'unitType{i+1} = "{unit}"')
    elif 'collect' in plan:
      lines.append(f'planType = "Collect{plan["collect"].capitalize()}"')
      lines.append(f'planPriority = {planPriority}')
      lines.append(f'buildIfNoIdle = {scavnoidle}')
    if 'when' in plan:
      lines.append('planCondition = "Lua"')
      lines.append(f'LuaFunction = "validatePlan{planCount}"')
      luaLines.extend(conditionLines(plan, planCount, team))
    lines.append('')
    planCount += 1
    planPriority -= 10
  return lines, luaLines

def conditionLines(plan, count, team):
  lines = [ f'function validatePlan{count}(team, time)'
          , f'  return validate(\'{plan.get("build") or plan.get("upgrade")}\', {"{"}'
          ]
  first = True
  for k, v in plan['when'].items():
    if v > 0:
      lines.append(f'   {"" if first else ","} HAS_{v}_{k} = AIPUtil.CountUnits(team, "{k}", \'sameteam\', true) >= {v}')
    else:
      lines.append(f'   {"" if first else ","} LACKS_{-v}_{k} = AIPUtil.CountUnits(team, "{k}", \'sameteam\', true) < {-v}')
    first = False
  lines.extend([r'  })', 'end'])
  return lines

outdir = 'C:/Users/Mike/Documents/BZRModManager-v0.5.0.0/git/624970/FERemastered/master/baked/FE_RM_Config/FERemastered/BZ2CP/AIP/MPI/Scion/'
scion = 'C:/Users/Mike/Documents/BZRModManager-v0.5.0.0/git/624970/FERemastered/master/FE_RM_Source/scripts/scionaip.yaml'
for team in range(6,9):
  planlines, luaLines = yamlToLines(fromYamlFile(scion), 'f', team)
  writeLines(planlines, outdir + f'fermpi_0_f_{team}.aip')
  writeLines(luaLines, outdir + f'fermpi_0_f_{team}.lua')
