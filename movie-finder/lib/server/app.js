var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');
const cors = require('cors');

var app = express();

app.use(cors());
app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use('/', checkAuth);

let authorize = true;

function checkAuth(req, res, next) {
  if (authorize) {
    next();
  } else {
    res.sendStatus(401);
  }
}

app.get('/', (req, res) => {  
  res.json({
    message: 'Entry GET req'
  });
})


module.exports = app;