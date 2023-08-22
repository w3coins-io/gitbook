# Empower

**EmpowerChain** is an innovative, tailored blockchain network designed to support the circular economy and promote equal opportunities for stakeholders in the global decentralized waste management ecosystem. EmpowerChain enables various parties to collaborate and create sustainable solutions for our planet's waste management challenges by providing a trustless and lock-in-free platform.

### [Stake now!](https://explorer.w3coins.io/EMPOWER-TESTNET/staking/empowervaloper1kk3h9ny7dxq5emc6ye4etxcafenpfzd6zw94dn)

## **Chain explorer**

* [https://explorer.w3coins.io/EMPOWER-TESTNET](https://explorer.w3coins.io/EMPOWER-TESTNET)

## Community Tools and Services

#### **RPC**

```
https://empower-testnet-rpc.w3coins.io
```

#### **gRPC**

```
empower-testnet-grpc.w3coins.io:17490
```

#### **API**

```
https://empower-testnet-api.w3coins.io
```

#### **Seed Node**

```
91706fd6ec45e38661ba7bb7567fc572b738c3ea@seed-node.w3coins.io:17466
```

#### **Addrbook**&#x20;

```
wget -O addrbook.json https://s3.eu-central-1.amazonaws.com/w3coins.io/addrbook/empower-testnet/addrbook.json --inet4-only
mv addrbook.json ~/.empowerchain/config
```

## Snapshot

Automatic snapshots occur every 24 hours, commencing at 07:00 UTC.

### [Download the latest snapshot.](https://s3.eu-central-1.amazonaws.com/w3coins.io/snapshots/empower-testnet/empower\_snapsot\_latest.tar.lz4)

## State sync

**Stop the node**

```
sudo systemctl stop empowerd
```

**Reset the node**

```
cp $HOME/.empowerchain/data/priv_validator_state.json $HOME/.empowerchain/priv_validator_state.json.backup
empowerd tendermint unsafe-reset-all --home $HOME/.empowerchain
```

**Get and configure the state sync information**

```
SNAP_RPC="https://empower-testnet-rpc.w3coins.io:443"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height);
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000));
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash) 
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH && sleep 2
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ;
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ;
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ;
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ;
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.empowerchain/config/config.toml
```

```
curl https://s3.eu-central-1.amazonaws.com/w3coins.io/wasm/empower-testnet/wasmonly.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.empowerchain
mv $HOME/.empowerchain/priv_validator_state.json.backup $HOME/.empowerchain/data/priv_validator_state.json
```

**Restart the node**

```
sudo systemctl restart empowerd && sudo journalctl -u empowerd -f
```

## IBC&#x20;

Empower Chain **<-->** Cosmos Hub

Empower Chain **<-->** Osmosis

Empower Chain **<-->** Stargaze

Empower Chain **<-->** Nibiru Chain
