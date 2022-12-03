


dir = 'C:/Users/Mike/Documents/BZRModManager-v0.5.0.0/git/624970/FERemastered/master/baked/FE_RM_Config/FERemastered/BZ2CP/AIP/MPI/'
fn = 'EDF/fermpi_0_i_6.aip'

basedirs = {7:3, 8:1} # 0S 1W 2N 3E

for i in range(7,9):
  with open(dir + fn, 'r') as fin:
    aip = fin.read()
  with open(dir + fn.replace('aip', 'lua'), 'r') as fin:
    lua = fin.read()
  aip = aip.replace('_6"', f'_{i}"')
  aip = aip.replace('baseDir = 2', f'baseDir = {basedirs[i]}')
  with open(dir + f'EDF/fermpi_0_i_{i}.aip', 'w') as file:
    file.write(aip)
  with open(dir + f'EDF/fermpi_0_i_{i}.lua', 'w') as file:
    file.write(lua)