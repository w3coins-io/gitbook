# Cosmos hub

**Cosmos Hub** is the first of thousands of interconnected blockchains that will eventually comprise the Cosmos Network. The primary token of the Cosmos Hub is the ATOM, but the Hub will support many tokens in the future.

### [Stake now!](https://explorer.w3coins.io/COSMOS-TESTNET/staking/cosmosvaloper1uy97y2f8fm7l28tl0mr75pgdaf2rzxsg33zfpq)

## **Chain explorer**

* [https://explorer.w3coins.io/COSMOS-TESTNET](https://explorer.w3coins.io/COSMOS-TESTNET)

## Community Tools and Services

#### **RPC**

```
https://cosmos-testnet-rpc.w3coins.io
```

#### **gRPC**

```
cosmos-testnet-grpc:9940
```

#### **API**

```
https://cosmos-testnet-api.w3coins.io
```

#### **Seed Node**

```
91706fd6ec45e38661ba7bb7567fc572b738c3ea@seed-node.w3coins.io:23466
```

#### **Addrbook**&#x20;

```
wget -O addrbook.json https://s3.eu-central-1.amazonaws.com/w3coins.io/addrbook/cosmos-testnet/addrbook.json --inet4-only
mv addrbook.json ~/.gaia/config
```

#### **Genesis**

```
wget -O genesis.json https://s3.eu-central-1.amazonaws.com/w3coins.io/genesis/cosmos-testnet/genesis.json --inet4-only
mv genesis.json ~/.gaia/config
```

## Snapshot

Automatic snapshots occur every 24 hours, commencing at 05:00 UTC.

### [Download the latest snapshot.](https://s3.eu-central-1.amazonaws.com/w3coins.io/snapshots/cosmos-testnet/cosmos\_snapsot\_latest.tar.lz4)

## State sync

**Stop the node**

```
sudo systemctl stop cosmos
```

**Reset the node**

```
cp $HOME/.gaia/data/priv_validator_state.json $HOME/.gaia/priv_validator_state.json.backup
cosmos tendermint unsafe-reset-all --home $HOME/.gaia
```

**Get and configure the state sync information**

```
SNAP_RPC="https://cosmos-testnet-rpc.w3coins.io"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height);
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000));
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash) 
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH && sleep 2
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ;
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ;
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ;
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ;
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.gaia/config/config.toml
```

```
mv $HOME/.gaia/priv_validator_state.json.backup $HOME/.gaia/data/priv_validator_state.json
```

**Restart the node**

```
sudo systemctl restart cosmos && sudo journalctl -u cosmos -f
```

####
