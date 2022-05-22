import mysql from "mysql2/promise";

let connection = null;
let connectionOptions = null;

try {
  connectionOptions = {
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    host: process.env.DB_HOST,
    database: process.env.DB_NAME,
    port: process.env.DB_PORT || 3306,
    multipleStatements: true,
  };

  connection = await mysql.createConnection(connectionOptions);
} catch (error) {
  console.log(error.message);
  console.log("Could not connect to databse with options: ", connectionOptions);
  process.exit(1);
}

const getAuthenticatedUser = async credentials => {
  if (connection == null) {
    throw new Error("could not connect to database");
  }
  const [rows] = await connection.execute("CALL GetAuthenticatedUser(?,?)", [
    credentials.username,
    credentials.password,
  ]);

  return rows[0][0];
};

const createAccount = async args => {
  const params = {
    name: args.name,
    email: args.email,
    username: args.username,
    password: args.password,
  };
  const procParams = Object.values(params);

  const [result] = await connection.execute("CALL CreateUser(?,?,?,?);", procParams);

  return result?.[0]?.[0];
};

export { getAuthenticatedUser, createAccount };
