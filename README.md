# Alphonso GI Tagging System

## Deployment & Testing

### Compile & Test Locally

```bash
forge build
forge test
```

### Setup `.env`(given below is fake private key keep in mind never share private key )

```env
ADMIN_ADDRESS=
LAB_ADDRESS=
REGULATOR_ADDRESS=
RPC=https://sepolia.infura.io/v3/
PRIVATE_KEY=
ETHERSCAN_API_KEY=


CONTRACT=0xe47a734d707f99e8573c4692139f75342c162174


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

## smart contract test and coverage

```
Ran 8 tests for test/AlphonsoGI.t.sol:AlphonsoTraceTest
[PASS] test_add_remove_farmers() (gas: 65759)
[PASS] test_approveGI_fake_regulator() (gas: 14184)
[PASS] test_approveGI_success() (gas: 193027)
[PASS] test_recordHarvest() (gas: 156594)
[PASS] test_recordHarvest_fake_farmer_call() (gas: 16962)
[PASS] test_recordQuality() (gas: 183520)
[PASS] test_recordQuality_fake_lab_admin() (gas: 15176)
[PASS] test_verifyGI() (gas: 187164)
Suite result: ok. 8 passed; 0 failed; 0 skipped; finished in 2.59ms (3.30ms CPU time)

Ran 1 test suite in 11.46ms (2.59ms CPU time): 8 tests passed, 0 failed, 0 skipped (8 total tests)

╭---------------------+-----------------+-----------------+---------------+---------------╮
| File                | % Lines         | % Statements    | % Branches    | % Funcs       |
+=========================================================================================+
| script/Deploy.s.sol | 0.00% (0/9)     | 0.00% (0/10)    | 100.00% (0/0) | 0.00% (0/2)   |
|---------------------+-----------------+-----------------+---------------+---------------|
| src/AlphonsoGI.sol  | 100.00% (27/27) | 100.00% (20/20) | 64.29% (9/14) | 100.00% (7/7) |
|---------------------+-----------------+-----------------+---------------+---------------|
| Total               | 75.00% (27/36)  | 66.67% (20/30)  | 64.29% (9/14) | 77.78% (7/9)  |
╰---------------------+-----------------+-----------------+---------------+---------------╯
```
