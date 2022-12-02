import json, io

def writeValue(f:io.TextIOWrapper, key:str, value):
  indent = len(key)-len(key.lstrip('.'))
  key = key.lstrip('.')
  if value is None:
    f.writelines([f'{" " * indent}{key} =\n'])
  elif isinstance(value, list):
      if key.endswith('#'):
        f.writelines([f'{" " * indent}{key.rstrip("#")} [1] =\n'])
      else:
        f.writelines([f'{" " * indent}{key.rstrip("#")} =\n'])
      for o in value:
        for k, v in o.items():
          writeValue(f, k, v)
  elif isinstance(value, dict):
    return
  else:
    if key.endswith('#'):
      f.writelines([f'{" " * indent}{key.rstrip("#")} [1] =\n', f'{value}\n'])
    else:
      f.writelines([f'{" " * indent}{key} = {value}\n'])

def writeBZN(json, fn):
  with open(fn, 'w') as f:
    for k, v in json['header'].items():
      writeValue(f, k, v)
    for k, v in json['header2'].items():
      writeValue(f, k, v)
    for o in json['objects']:
      f.writelines([f'[GameObject]\n'])
      for k, v in o.items():
        writeValue(f, k, v)

fin = r'C:\Users\Mike\Documents\My Games\Battlezone Combat Commander\FE\addon\missions\Multiplayer\test\flat.json'
fout = r'C:\Users\Mike\Documents\My Games\Battlezone Combat Commander\FE\addon\missions\Multiplayer\test\test.bzn'
with open(fin, 'r') as f:
  writeBZN(json.load(f), fout)