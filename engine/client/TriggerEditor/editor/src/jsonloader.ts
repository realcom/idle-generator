import * as path from "path";
import * as fs from "fs";

import {PATH_DATA} from "./pathloader"

interface stringInterface {
  category?: string;
  english?: string;
  id?: number;
  key?: string;
  korean?: string;
}

export function loadString() {
  const stringsRaw = JSON.parse(fs.readFileSync(path.join(PATH_DATA, "Strings.json"), "utf8"));

  // TODO: remove json string loader
  const strings = {
    strings: [] as stringInterface[]
  };

  for (let i = 0; i < stringsRaw.strings.length; i++) {
    if (!('category' in stringsRaw.strings[i]) || stringsRaw.strings[i].category === "Editor" || stringsRaw.strings[i].category === "Dialog") {
      strings.strings.push(stringsRaw.strings[i]);
    }
  }

  return strings;
}

let triggerJson, methodMetadata;

try {
  triggerJson = JSON.parse(fs.readFileSync(path.join(PATH_DATA, "Triggers.json"), "utf8"));
  methodMetadata = ('triggerMethods' in triggerJson) ? triggerJson.triggerMethods : {};
} catch (e) {
  console.error('Failed to load Triggers.json');
  console.error(e);
  triggerJson = {};
}

export {triggerJson, methodMetadata}
