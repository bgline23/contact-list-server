import express from "express";
import { verifyToken } from "../middleware/JWT.js";
import * as db from "../database.js";

const router = express.Router();

router.post("/create",verifyToken, async (req, res) => {
  try {

    const user = await db.createNote(req.body.contact_id);
    res.json(user);
  } catch (error) {
    console.log("Cant create user account: ", error.message);
    res.status(500).send(error.message);
  }
});


export { router };
