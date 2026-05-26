let canvas = document.getElementById("map");

let size = Math.min(window.innerWidth, window.innerHeight-180);
canvas.width = size;
canvas.height = size;

let ctx = canvas.getContext("2d");
let width = canvas.width;
let height = canvas.height;

if (window.devicePixelRatio > 1) {
  let canvasWidth = canvas.width;
  let canvasHeight = canvas.height;

  canvas.width = canvasWidth * window.devicePixelRatio;
  canvas.height = canvasHeight * window.devicePixelRatio;
  canvas.style.width = canvasWidth + "px";
  canvas.style.height = canvasHeight + "px";

  ctx.scale(window.devicePixelRatio, window.devicePixelRatio);
}

let mapUrl = './Maps.json';
let mapData = null;

fetchMap(mapUrl)

let scale = 1;
let xMin, xMax, yMin, yMax;

document.getElementById('coord').innerHTML = 'X: 0, Y: 0';

function fetchMap(url) {
  fetch(url)
      .then(response => response.json())
      .then(data => {
        mapData = data;
        document.getElementById('nav0').innerHTML = '';
        data.maps.forEach((map) => {
          let button = document.createElement("button");
          button.innerHTML = map.scene;
          button.onclick = () => {
            drawTerrainSelector(map);
          };
          document.getElementById('nav0').append(button);
        });
        drawTerrainSelector(data.maps[0]);
      });
}

function loadMap(data) {
  mapData = data;
  document.getElementById('nav0').innerHTML = '';
  data.maps.forEach((map) => {
    let button = document.createElement("button");
    button.innerHTML = map.scene;
    button.onclick = () => {
      drawTerrainSelector(map);
    };
    document.getElementById('nav0').append(button);
  });
  drawTerrainSelector(data.maps[0]);
}

function loadPath(data) {
  pathData = data;
  let hue = Math.random() * 360;
  ctx.strokeStyle = 'hsl(' + hue + ', 100%, 50%)';

  for (let i in pathData) {

    if (i == 0) continue;
    let x1, y1, x2, y2, x3, y3;
    x1 = (pathData[i-1].X - xMin) * scale;
    y1 = (pathData[i-1].Y - yMax) * scale;
    x2 = (pathData[i].X - xMin) * scale;
    y2 = (pathData[i].Y - yMax) * scale;

    //invert y
    y1 = -y1;
    y2 = -y2;

    ctx.lineWidth = 2;
    ctx.beginPath();
    ctx.moveTo(x1, y1);
    ctx.lineTo(x2, y2);
    ctx.stroke();
  }
}

function drawTerrainSelector(map) {
  let terrains = map.terrains;
  document.getElementById('nav1').innerHTML = '';
  terrains.forEach((terrain, index) => {
    let button = document.createElement("button");
    button.innerHTML = 'Terrain ' + index;
    button.onclick = () => {
      drawMap(terrain, index);
    };
    document.getElementById('nav1').append(button);
  });
  drawMap(terrains[0], 0);
}

function drawMap(terrain, index) {
  let triangles = terrain.triangles;
  let vertices = terrain.vertices;

  // 
  ctx.clearRect(0, 0, width, height);

  // fit map to canvas
  xMin = Infinity;
  xMax = -Infinity;
  yMin = Infinity;
  yMax = -Infinity;

  for (let i in vertices) {
    let vertex = vertices[i];
    let x, y;
    if ('x' in vertex.position) {
      x = vertex.position.x;
    } else {
      x = 0;
      vertex.position.x = 0;
    }
    xMin = Math.min(xMin, x);
    xMax = Math.max(xMax, x);

    // note: if any vertex not contained in a triangle exists, scaling will be incorrect
    if ('y' in vertex.position) {
      y = vertex.position.y;
    } else {
      y = 0;
      vertex.position.y = 0;
    }
    yMin = Math.min(yMin, y);
    yMax = Math.max(yMax, y);
  }

  let xScale = width / (xMax - xMin);
  let yScale = height / (yMax - yMin);
  scale = Math.min(xScale, yScale);

  let info = '';
  info += 'Loaded terrain: ' + index + '<br>';
  info += 'x bound: (' + (0|xMin*100)/100 + ', ' + (0|xMax*100)/100 + ')<br>';
  info += 'y bound: (' + (0|yMin*100)/100 + ', ' + (0|yMax*100)/100 + ')<br>';
  info += 'scale: ' + (0|scale*100)/100;
  document.getElementById('info').innerHTML = info;

  // fill and stroke triangles
  for (let i in triangles) {
    let triangle = triangles[i];
    let v1, v2, v3;
    if ('v1' in triangle) v1 = vertices[triangle.v1];
    else {
      v1 = vertices[0];
    }
    if ('v2' in triangle) v2 = vertices[triangle.v2];
    else {
      v2 = vertices[0];
    }
    if ('v3' in triangle) v3 = vertices[triangle.v3];
    else {
      v3 = vertices[0];
    }

    let x1, y1, x2, y2, x3, y3;
    x1 = (v1.position.x - xMin) * scale;
    y1 = (v1.position.y - yMax) * scale;
    x2 = (v2.position.x - xMin) * scale;
    y2 = (v2.position.y - yMax) * scale;
    x3 = (v3.position.x - xMin) * scale;
    y3 = (v3.position.y - yMax) * scale;

    //invert y
    y1 = -y1;
    y2 = -y2;
    y3 = -y3;

    ctx.fillStyle = "#444";
    ctx.strokeStyle = "#fff";
    ctx.lineWidth = 1;
    ctx.beginPath();
    ctx.moveTo(x1, y1);
    ctx.lineTo(x2, y2);
    ctx.lineTo(x3, y3);
    ctx.fill();
    ctx.closePath();
    ctx.stroke();
  }

  drawGrid(xMin, xMax, yMin, yMax, gridsize=1.0);
}

function drawGrid(xMin, xMax, yMin, yMax, gridsize) {
  ctx.strokeStyle = "#666";
  ctx.lineWidth = 1;
  for (let x = Math.ceil(xMin); x <= xMax; x += gridsize) {
    let x0 = (x - xMin) * scale;
    ctx.beginPath();
    ctx.moveTo(x0, yMin*scale);
    ctx.lineTo(x0, (yMax-yMin)*scale);
    ctx.stroke();
  }
  for (let y = Math.ceil(yMin); y <= yMax; y += gridsize) {
    let y0 = (yMax - y) * scale;
    ctx.beginPath();
    ctx.moveTo(xMin*scale, y0);
    ctx.lineTo((xMax-xMin)*scale, y0);
    ctx.stroke();
  }

  // draw grid legends
  ctx.fillStyle = "#fff";
  ctx.font = "12px sans-serif";
  for (let x = Math.floor(xMin); x <= xMax; x += gridsize) {
    let x0 = (x - xMin) * scale;
    ctx.fillText(x, x0+5, yMax*scale+15);
  }
  for (let y = Math.floor(yMin); y <= yMax; y += gridsize) {
    let y0 = (yMax - y) * scale;
    ctx.fillText(y, (xMax-xMin)*scale-50, y0-5);
  }
}

function drawTrianglePoint(triangle, vertices) {
  let v1, v2, v3;
  if ('v1' in triangle) v1 = vertices[triangle.v1];
  if ('v2' in triangle) v2 = vertices[triangle.v2];
  if ('v3' in triangle) v3 = vertices[triangle.v3];

  ctx.fillStyle = "#f00";
  
  ctx.beginPath();
  if (v1) {
    let x = (v1.position.x - xMin) * scale;
    let y = (yMax - v1.position.y - yMin) * scale;
    ctx.arc(x, y, 5, 0, 2 * Math.PI);
    ctx.fill();
  }
  if (v2) {
    let x = (v2.position.x - xMin) * scale;
    let y = (yMax - v2.position.y - yMin) * scale;
    ctx.arc(x, y, 5, 0, 2 * Math.PI);
    ctx.fill();
  }
  if (v3) {
    let x = (v3.position.x - xMin) * scale;
    let y = (yMax - v3.position.y - yMin) * scale;
    ctx.arc(x, y, 5, 0, 2 * Math.PI);
    ctx.fill();
  }
}

// mouse event on the canvas
canvas.addEventListener('mousemove', function(e) {
  let rect = canvas.getBoundingClientRect();
  let x = e.clientX - rect.left;
  let y = e.clientY - rect.top;
  document.getElementById("coord").innerHTML = "X: " + (0|(x / scale + xMin)*100)/100 + ", Y: " + (0|(-y / scale + yMax)*100)/100;
});



;['dragenter', 'dragover'].forEach(eventName => {
  document.body.addEventListener(eventName, (e) => {
    e.preventDefault();
    e.stopPropagation();
    document.getElementById('overlay').setAttribute('style', 'display: flex');
  });
})

;['dragleave', 'drop'].forEach(eventName => {
  document.getElementById('overlay').addEventListener(eventName, (e) => {
    e.preventDefault();
    e.stopPropagation();
    document.getElementById('overlay').setAttribute('style', 'display: none');

    var datatransfer = e.dataTransfer;
    var files = datatransfer.files;

    // read file and load
    var reader = new FileReader();
    reader.onload = function (e) {
      try {
        map = JSON.parse(e.target.result);
        loadMap(map);
      } catch (error) {
        try {
          loadPath(map);
        } catch (error) {
          console.log(error);
        }
      }
    };
    reader.readAsText(files[0]);

  });
})
