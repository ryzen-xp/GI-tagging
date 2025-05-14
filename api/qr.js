const QRCode = require("qrcode");
const fs = require("fs");
const path = require("path");

const readline = require("readline").createInterface({
  input: process.stdin,
  output: process.stdout,
});

readline.question("enter_Batch_ID: ", (batchID) => {
  const url = `http://localhost/verify/${batchID}`;
  const Path = path.join(__dirname, `${batchID}.png`);

  QRCode.toFile(
    Path,
    url,
    {
      color: {
        dark: "#000000",
        light: "#ffffff",
      },
    },
    (err) => {
      if (err) {
        console.error("generation failed:", err);
      } else {
        console.log(`QR  generated: ${Path}`);
      }
      readline.close();
    }
  );
});
