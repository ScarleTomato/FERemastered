import oyaml as yaml
from copy import deepcopy

teams = {'102':'6', '119':'7', '136':'8'}
labels = {
    'ibrecy': 'Recycler_'
  , 'ibarmo': 'armory_edf_'
  , 'ibbomb': 'bomber_edf_'
  , 'ibcbun': 'bunker_edf_'
  , 'ibfact': 'factory_edf_'
  , 'ibsbay': 'sbay_edf_'
  , 'ibtcen': 'tech_edf_'
  , 'ibtrain': 'training_edf_'
  , 'ibpgen': 'pgen#_edf_'
  , 'ibgtow': 'gtow#_'
}
vanillapaths = [
  'stage1', 'stage2', 'stage3'
  , 'hold1', 'hold2', 'hold3', 'hold4'
  , 'tank1', 'tank2', 'tank3'
  , 'tankEnemy1', 'tankEnemy2', 'tankEnemy3'
  , 'edge_path', 'Recycler'
]

def toNavObj(path, x, y, z):
  return {
          "objClass": "apserv",
          "seqno#": "0",
          "team#": "0",
          "isUser#": "false",
          "objAddr": "0",
          "transform#": [
            {
              "..right.x#": "1.00000000e+00",
              "..right.y#": "0.00000000e+00",
              "..right.z#": "0.00000000e+00",
              "..up.x#": "0.00000000e+00",
              "..up.y#": "1.00000000e+00",
              "..up.z#": "0.00000000e+00",
              "..front.x#": "0.00000000e+00",
              "..front.y#": "0.00000000e+00",
              "..front.z#": "1.00000000e+00",
              "..posit.x#": path['points#'][0]['..x#'], #"-8.09658051e+01",
              "..posit.y#": y, #"5.00000000e+00",
              "..posit.z#": path['points#'][0]['..z#'] #"4.27069092e+02"
            }
          ],
          "illumination#": "1.00000000e+00",
          "euler": [
            {
              ".mass#": "1.25000146e+04",
              ".mass_inv#": "7.99999034e-05",
              ".v_mag#": "0.00000000e+00",
              ".v_mag_inv#": "1.00000002e+30",
              ".I#": "9.37501797e+04",
              ".k_i#": "1.06666466e-05",
              ".v#": [
                {
                  "..x#": "0.00000000e+00",
                  "..y#": "0.00000000e+00",
                  "..z#": "0.00000000e+00"
                }
              ],
              ".omega#": [
                {
                  "..x#": "0.00000000e+00",
                  "..y#": "0.00000000e+00",
                  "..z#": "0.00000000e+00"
                }
              ],
              ".Accel#": [
                {
                  "..x#": "0.00000000e+00",
                  "..y#": "0.00000000e+00",
                  "..z#": "0.00000000e+00"
                }
              ]
            }
          ],
          "name": path['label'],
          "saveFlags#": "108",
          "isVisible#": "65535",
          "EffectsMask#": "65535",
          "isSeen#": "0",
          "groupNumber#": "0",
          "undefaicmd": None,
          "priority#": "0",
          "what": "00000000",
          "who#": "0",
          "where": "00000000",
          "param#": "0",
          "aiProcess#": "false",
          "independence#": "1"
        }

def objtopath(top):
  newobjects = []
  newpaths = []
  for o in top['objects']:
    if int(o['team#']) > 0 and o['objClass'] in labels.keys():
      # grab the label with team number
      label = labels[o['objClass']] + teams[o['team#']]
      # add the count from the object label if this is an enumerated bldg
      if '#' in label:
        label = label.replace('#', o['label'])
      # create a new path
      newpath = {
          'sObject': 0
        , 'size#': 0
        , 'label': label
        , 'pointCount#': 0
        , 'points#': [{
            '..x#': '{:.8e}'.format(float(o['transform#'][0]['..posit.x#']) + 0.000001)
          , '..z#': '{:.8e}'.format(float(o['transform#'][0]['..posit.z#']) + 0.000001)
        }]
        , 'pathType': '00000000'
      }
      # add nav of path point
      newobjects.append(toNavObj(newpath, float(o['transform#'][0]['..posit.x#']), float(o['transform#'][0]['..posit.y#']), float(o['transform#'][0]['..posit.z#'])))
      newpaths.append(newpath)
    elif o['objClass'] == 'ipdrop':
      continue
    else:
      newobjects.append(o)
  top['objects'] = newobjects
  ## Remove any paths that aren't vanilla
  for p in top['paths']:
    if p['label'] in vanillapaths:
      newpaths.append(p)
  top['paths'] = newpaths
  return top

dir = r'C:/Users/Mike/Documents/My Games/Battlezone Combat Commander/FE/addon/missions/Multiplayer/test/'
fn = 'test'
# with open(fin, 'r') as f:
#   writeBZN(json.load(f), fout)
with open(dir + f'{fn}.yaml', 'r') as fin, open(dir + f'{fn}_path.yaml', 'w') as fout:
  yaml.dump(objtopath(yaml.load(fin, Loader=yaml.Loader)), fout)
print(f'new paths written to {fn}_path.yaml')