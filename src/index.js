if ( ! process.env.DCV ) {
  process.env.DCV = 'v1';
}

const fs = require('fs');
const path = require('path');
const multer = require('multer');

const { Server } = require("socket.io");

const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const morgan = require('morgan');
const accessLogStream = fs.createWriteStream(path.join(__dirname, 'access.log'), { flags: 'a' })
const session = require('express-session');
const MySQLStore = require('express-mysql-session');

// mysql
const pool = require('./database');
const DCQuery = new (require('./query'))(pool.default);
const WHQuery = new (require('./wh-query'))(pool.warehouse);
const sessionStore = new MySQLStore({
  schema: {
    tableName: 'dc_sessions'
  }
}/* session store options */, pool.default);

const app = express();
app.use(cors());
app.use(bodyParser.json());
app.use(morgan('combined', { stream: accessLogStream }));
app.use(session({
  secret: 'z',
  resave: false,
  saveUninitialized: true,
  store: sessionStore
}));

// websocket for puzzle update
var server = require('http').Server(app);
// http server를 socket.io server로 upgrade한다
const io = new Server(server, {
  cors: {
    origin: ["*"],
    handlePreflightRequest: (req, res) => {
      res.writeHead(200, {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "GET,POST",
        "Access-Control-Allow-Headers": "my-custom-header",
        "Access-Control-Allow-Credentials": true,
      });
    },
  },
  allowEIO3: true // false by default
});

// entrance
require('./entrance/init')(app, DCQuery);

// admin
require('./admin/init')(app, path, multer, DCQuery);

// user
require('./user/init')(app, path, multer, DCQuery, io);

// assist
require('./assist/init')(app, DCQuery);

// warehouse
require('./warehouse/init')(app, WHQuery);

// media-files
require('./media-files/init')(app, DCQuery);

app.use(express.static('public'));

console.log( 'process.env.NODE_PORT : ', process.env.NODE_PORT );

// for real time puzzle update
io.on('connection', function(socket) {
  socket.on('open_puzzle_box', function(data) {
    console.log( 'on open_puzzle_box data : ', data );
    socket.emit('puzzle_box_opened', data);
  });
  
  socket.on('disconnect', () => {
    console.log('user disconnected');
  })
});

let PORT = process.env.NODE_PORT || 8081;
server.listen(PORT, 'localhost');
