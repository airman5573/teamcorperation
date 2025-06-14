const util = require("util");
const mysql = require("mysql");

/* ------------------------------------------------------------------------- *
 *  Default DB Connection
/* ------------------------------------------------------------------------- */
let config = {
  connectionLimit: 20,
  host: "localhost",
  user: "teamcorperation_db_user",
  database: `teamcorperation_main`,
};
let password = "root";
if (process.env.NODE_ENV == "production") {
  password = "Thoumas138!";
}
config.password = password;
const pool = mysql.createPool(config);

// Ping database to check for common exception errors.
pool.getConnection((err, connection) => {
  if (err) {
    if (err.code === "PROTOCOL_CONNECTION_LOST") {
      console.error("Database connection was closed.");
    }
    if (err.code === "ER_CON_COUNT_ERROR") {
      console.error("Database has too many connections.");
    }
    if (err.code === "ECONNREFUSED") {
      console.error("Database connection was refused.");
    }
  }
  // 이거 꼭 필요하다. 내가 이 커넥션을 갖고있으면, 다른 사람이 사용하지 못한다.
  // 내가 어차피 pool.query를 써도, 안에서는 다 쓰고 나서 release한다.
  if (connection) connection.release();
  return;
});

// Promisify for Node.js async/await.
pool.query = util.promisify(pool.query);

module.exports = { default: pool, warehouse: pool };
