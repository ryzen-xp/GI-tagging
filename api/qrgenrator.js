const QRCode = require("qrcode");
const fs = require("fs");
const path = require("path");

const batchID = "144";
const url = `http://localhost/verify/${batchID}`;

const outputPath = path.join(__dirname, `${batchID}.png`);

QRCode.toFile(
  outputPath,
  url,
  {
    color: {
      dark: "#000000",
      light: "#ffffff",
    },
  },
  function (err) {
    if (err) return console.error("QR Code generation failed:", err);
    console.log(`QR Code generated: ${outputPath}`);
  }
);
