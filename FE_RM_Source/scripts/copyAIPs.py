import os
from pathlib import Path

def toFile(o, path):
  print(f'saved to {os.path.basename(path)}')
  with open(path, 'w') as fout:
    fout.write(o)

def fromFile(path):
  print(f'Reading {os.path.basename(path)}')
  with open(path, 'r') as fin:
    return fin.read()

dir = Path('C:/Users/Mike/Documents/BZRModManager-v0.5.0.0/git/624970/FERemastered/master/baked/FE_RM_Config/FERemastered/BZ2CP/AIP/MPI/')

basedirs = {7:3, 8:1} # 0S 1W 2N 3E

for subdir, race in [('EDF', 'i'), ('Scion', 'f')]:
  for team in range(7,9):
    aip = fromFile(dir / subdir / f'fermpi_0_{race}_6.aip')
    lua = fromFile(dir / subdir / f'fermpi_0_{race}_6.lua')

    aip = aip.replace('_6"', f'_{team}"')
    aip = aip.replace('baseDir = 2', f'baseDir = {basedirs[team]}')
    
    toFile(aip, dir / subdir / f'fermpi_0_{race}_{team}.aip')
    toFile(lua, dir / subdir / f'fermpi_0_{race}_{team}.lua')