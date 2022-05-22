import express from "express";
import * as db from "../database.js";
import { verifyToken } from "../middleware/JWT.js";

const router = express.Router();

router.post("/create", verifyToken, async (req, res) => {
  try {
    
    const contact = await db.createContact(req.body);

    res.send(contact);
  } catch (error) {
    res.status(500).send(error.message);
  }
});



export { router };
