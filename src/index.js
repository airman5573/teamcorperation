if ( ! process.env.DCV ) {
  process.env.DCV = 'v1';
}

const fs = require('fs');
const path = require('path');
const multer = require('multer');

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
const WHQuery = new (require('./wh-query'))(pool.default);
const sessionStore = new MySQLStore({
  schema: {
    tableName: 'dc_sessions'
  }
}/* session store options */, pool.default);

const app = express();

// app.use(cors({
//   origin: 'https://teamcorperation.kr', 
//   credentials: true,
//   methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
//   allowedHeaders: ['Content-Type', 'Authorization', 'Cookie'],
//   exposedHeaders: ['set-cookie']
// }));

app.use(cors());

// (1) 프록시 신뢰 설정
// app.set('trust proxy', 1);

// (2) 세션 미들웨어
app.use(session({
  secret: 'asol_teamcorperation_scret_key',
  resave: false,
  saveUninitialized: true,
  store: sessionStore
}));

app.use(bodyParser.json());
app.use(morgan('combined', { stream: accessLogStream }));

// websocket for puzzle update
var server = require('http').createServer(app);
// http server를 socket.io server로 upgrade한다
const io = require("socket.io")(server, {
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
    io.emit('puzzle_box_opened', data);
  });
  
  socket.on('disconnect', () => {
    console.log('user disconnected');
  })
});

let PORT = process.env.NODE_PORT || 8081;
let HOST = process.env.NODE_HOST || (process.env.NODE_ENV === 'production' ? '0.0.0.0' : 'localhost');
server.listen(PORT, HOST);
