# Alphonso GI Tagging System

## Deployment & Testing

### Compile & Test Locally

```bash
forge build
forge test
```

### Deploy to Sepolia

```bash
forge script script/Deploy.s.sol:DeployScript \
  --rpc-url $RPC \
  --private-key $PRIVATE_KEY \
  --broadcast \
  --verify \
  --etherscan-api-key $ETHERSCAN_API_KEY

```

---

## Run Backend API

### 1. Setup `.env`(given below is fake private key keep in mind never share private key )

```env
ADMIN_ADDRESS=
LAB_ADDRESS=
REGULATOR_ADDRESS=
RPC=https://sepolia.infura.io/v3/
PRIVATE_KEY=
ETHERSCAN_API_KEY=


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

after that you give batchId number then it genrate qr .

### Output

Creates a PNG QR linking to(example ):

```
https://localhost/verify/144
```
