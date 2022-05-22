import express from "express";
import jwt from "jsonwebtoken";
import { encrypt } from "../helpers.js";
import * as db from "../database.js";

const router = express.Router();

router.post("/login", async (req, res) => {
  try {
    const credentials = {
      username: req.body.username,
      password: encrypt(req.body.password),
    };
    // search for user in DB
    const userResult = await db.getAuthenticatedUser(credentials);

    if (!userResult?.username) {
      res.status(401).send("Invalid credentials, please try again");
    }

    const token = encrypt(JSON.stringify(credentials));

    jwt.sign({ token }, process.env.API_SECRET, (err, token) => {
      res.json({
        user: userResult,
        token,
        success: true,
      });
    });
  } catch (error) {
    res.status(500).send(error.message);
  }
});

export { router };
