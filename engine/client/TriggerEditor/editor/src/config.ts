import { predefinedVariablesDataInterface } from './blocks';

// TODO: Add variable types.
// ['Display Name', 'type Name']
export const variableTypes = [
  ['Board', 'board'],
  ['Caller', 'caller'],
  ['State', 'state'],
  ['Slot Unit', 'unit'],
  ['Slot Skill', 'skill'],
  ['Slot Buff', 'buff'],
  ['Caller Unit', 'caller__unit'],
  ['Caller Skill', 'caller__skill'],
  ['Caller Buff', 'caller__buff'],
];

// TODO: Add predefined variables.
// ['Class Name': [{variable: 'Display Name', offset: 'Offset'}]
export const predefinedVariablesData = new Map<string, predefinedVariablesDataInterface[]>([
  ['UnitDeath', [{
    variable: 'Unit #',
    offset: 1000000,
  }]],
]);

// TODO: Add path candidates to look up.
export const pathCandidates = [
  './',
  'C:\\Projects\\zenonia-client',
  'D:\\Projects\\zenonia-client',
]

export const argumentTypes = new Map<string, string>([
  ['LocationId', 'StringKey']
])

export const teamTagKeys = new Map<string, number>([
  ['Neutral', 0],
  ['Player', 1],
  ['PlayerRed', 2],
  ['PlayerBlue', 3],
  ['Enemy', 4],
  ['EnemyElite', 5],
  ['EnemyBoss', 6],
])