import * as fs from "fs";
import path from "path";
import {editorStrings} from "./strings";

const isMac = process.platform === 'darwin';

import {pathCandidates} from "./config";

let pathCandidatesReal = pathCandidates;

if (isMac) {
  pathCandidatesReal = [];
  pathCandidatesReal.push('./');
  pathCandidatesReal.push('~/RiderProjects/zenonia-client');
  if (process.resourcesPath) pathCandidatesReal.push(path.join(process.resourcesPath, 'preferences'));
}
let clientPath = '';

const path_resource = "Client/Assets/Scripts/Commons/Resources/"
const path_game = "Client/Assets/Scripts/Commons/Game/"
const path_data = "Client/Assets/PatchResources"
let pathPrefix = '';

const i = 0;
let found = false;

for (const candidate of pathCandidatesReal) {
  pathPrefix = '';
  for (let i = 0; i < 20; i++) {
    if (fs.existsSync(path.join(pathPrefix, candidate, path_resource))) {
      clientPath = path.join(pathPrefix, candidate);
      found = true;
      break;
    }
    pathPrefix += '../';
  }
  if (found) break;
}

if (!found) {
  throw new Error(editorStrings.failedToFindClientPath);
}

export const PATH_RESOURCE = path.join(clientPath, path_resource);
export const PATH_GAME = path.join(clientPath, path_game);
export const PATH_DATA = path.join(clientPath, path_data);