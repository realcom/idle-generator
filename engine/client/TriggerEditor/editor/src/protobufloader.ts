import * as path from "path";
import * as fs from "fs";
import * as protobuf from "protobufjs";
import {PATH_RESOURCE, PATH_GAME} from "./pathloader"


export const resourceTrigger = protobuf.loadSync(path.join(PATH_RESOURCE, "ResourceTrigger.proto"));
export const resourceString = protobuf.loadSync(path.join(PATH_RESOURCE, "ResourceString.proto"));

const root = new protobuf.Root();
const rootDirs: string[] = [
  './'
];

root.resolvePath = (origin: string, target: string): string | null => {
  for (const dir of rootDirs) {
    const fullPath = path.join(dir, target);
    if (fs.existsSync(fullPath)) {
      return fullPath;
    }
  }
  return null;
};

export const resourceItemTypes = protobuf.loadSync(path.join(PATH_RESOURCE, "ResourceItem.proto"), root).lookupType('ResourceItem').toJSON();
export const resourceMapTypes = protobuf.loadSync(path.join(PATH_RESOURCE, "ResourceMap.proto"), root).lookupType('ResourceMap').toJSON();
export const eTags = protobuf.loadSync(path.join(PATH_RESOURCE, "Tags.proto"), root).lookupEnum('Tag').toJSON();
export const eGameBoardStates = protobuf.loadSync(path.join(PATH_GAME, "GameBoard.proto"), root).lookupType('GameBoard').lookupEnum('State').toJSON();