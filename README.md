# Alphonso GI Tagging System

## Deployment & Testing

### Compile & Test Locally

```bash
forge build
forge test
```

### Deploy to Sepolia

```bash
forge script script/Deploy.s.sol:DeployScript --rpc-url $RPC --private-key $PRIVATE_KEY --broadcast
```

---

## Run Backend API

### 1. Setup `.env`(given below is fake private key keep in mind never share private key )

```env
ADMIN_ADDRESS=0x74644a557Dd75DE3Eb51a6697abF61Dd13d93775
LAB_ADDRESS=0xfc73B87a6605e8929ACAd0cf2DCD46126611951e
REGULATOR_ADDRESS=0xF24d592c0C2D7a7896Dd419E96234FAB2f518fA3
RPC=https://sepolia.infura.io/v3/21266fb86e1443869b2bd28f2180a25c

PRIVATE_KEY=6d37a238c10c57276d9eabd37ec6156b19e619f045e01538cbd1993773c4f6c2


CONTRACT=0xe47a734d707f99e8573c4692139f75342c162174


```

### 2. Start Server

```bash
node api/server.js
```

## QR Code Generation

### Run Script

```bash
node api/qr.js
```

### Output

Creates a PNG QR linking to:

```
https://localhost/verify/114
```
