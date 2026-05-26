
export function loadLocationIdKeys() {
  const locationIdKeys = [['Unknown', 'Unknown']];
  const globalData = window.electronAPI.loadData('loadData');
  const globalStrings = globalData.strings;

  for (const key of globalStrings.strings) {
    if ('english' in key && key.english.startsWith('Location/')) {
      locationIdKeys.push([key.english.split('/').slice(1).join('/'), key.english]);
    }
  }

  return locationIdKeys;
}

export function loadStringKeys() {
  const stringKeys = [['Unknown', 'Unknown']];
  const globalData = window.electronAPI.loadData('loadData');
  const globalStrings = globalData.strings;
  for (const key of globalStrings.strings) {
    if ((!('category' in key) || key.category === 'Editor') && 'key' in key && key.key !== '') {
      stringKeys.push([key.key, key.key]);
    }
  }

  return stringKeys;
}

export function toSingleList(list: string[][]) {
  const singleList = [];
  for (const item of list) {
    singleList.push(item[1]);
  }
  return singleList;
}