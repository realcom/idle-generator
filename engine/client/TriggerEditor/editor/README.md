## How to Make This Mess Work

* TriggerEditor consist of two servers
  * A Node(+Webpack, Express, TypeScript) server that serves the editor and emits the TriggerIR code
  * A Python(+Flask) server that compiles the TriggerIR code into a JSON format

### Running the Node Server
1. Make sure you have Node.js installed and `node`, `npm`, and `npx` are in your `PATH`.
1. Navigate to the `editor` directory
```sh
$ cd editor
```
1. Install the necessary node modules
```sh
$ npm install
```
1. Start the server
```sh
$ npm run start
```

### Running the Python Server
1. Make sure you have Python 3 installed and `python3`, `pip3` are in your `PATH`.
1. Navigate to the `compiler` directory
```sh
$ cd compiler
```
1. Install the necessary python modules
```sh
$ pip3 install -r requirements.txt
```
1. Start the server
```sh
$ python3 app.py
```

### Using the Editor
1. Open a browser and navigate to `http://localhost:8080`

### Known UI issues
* Dropdown arrow is not rendered for inputs with datalist(used in the block variables) in Firefox.
* Firefox does not support the `showSaveFilePicker` API, so the 'save as' dialog will not show up in Firefox.