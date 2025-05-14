require("dotenv").config();
const express = require("express");
const fs = require("fs");
const Web3 = require("web3");
const path = require("path");

const ABI = JSON.parse(
  fs.readFileSync(
    path.join(__dirname, "../out/AlphonsoGI.sol/AlphonsoGI.json"),
    "utf8"
  )
);

const web3 = new Web3(process.env.RPC);

const contract = new web3.eth.Contract(ABI.abi, process.env.CONTRACT);

const app = express();
const port = 3000;

app.get("/verify/:batchID", async (req, res) => {
  try {
    const ID = req.params.batchID;
    const batchID = web3.utils.keccak256(ID);

    const giApproved = await contract.methods.verifyGI(batchID).call();
    res.json({ batchID: ID, giApproved });
  } catch (err) {
    res.status(500).json({ error: "Ffailed to fetch" });
  }
});

app.listen(port, () => {
  console.log(`running at http://localhost:${port}`);
});
