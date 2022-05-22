import express from "express";
import { decrypt, encrypt } from "../helpers.js";
import * as db from "../database.js";

const router = express.Router();

router.post("/account", async (req, res) => {
  try {
    req.body.password = encrypt(req.body.password);

    const user = await db.createAccount(req.body);
    res.json(user);
  } catch (error) {
    console.log("Cant create user account: ", error.message);
    res.status(500).send(error.message);
  }
});

export { router };
