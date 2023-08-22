# Nolus

**Nolus** is a DeFi project created to eliminate the inefficiencies of current money markets by providing an innovative solution for its users. The main product of Nolus is DeFi Lease, the world's first DeFi lease that allows users to make a real return on their initial investment.

### [Stake now!](https://explorer.w3coins.io/nolus/staking/nolusvaloper14uhx3rrqy5wat52ed663jyte70jm93335qfak0)  18-23% Expected reward rate

## **Chain explorer**

* [https://explorer.w3coins.io/nolus](https://explorer.w3coins.io/nolus)
* [https://nolus.explorers.guru/](https://nolus.explorers.guru/)

## Community Tools and Services

#### **RPC**

```
https://nolus-rpc.w3coins.io
```

#### **gRPC**

```
nolus-grpc.w3coins.io:19790
```

#### **API**

```
https://nolus-api.w3coins.io
```

#### **Seed Node**

```
91706fd6ec45e38661ba7bb7567fc572b738c3ea@seed-node.w3coins.io:23266
```

**Addrbook**

```
wget -O addrbook.json https://s3.eu-central-1.amazonaws.com/w3coins.io/addrbook/nolus-mainnet/addrbook.json --inet4-only
mv addrbook.json ~/.injectived/config
```

**Genesis**

```
wget -O genesis.json https://s3.eu-central-1.amazonaws.com/w3coins.io/genesis/nolus-mainnet/genesis.json --inet4-only
mv genesis.json ~/.injectived/config
```

## Snapshot

Automatic snapshots occur every 24 hours, commencing at 03:45 UTC.

### [Download the latest snapshot.](https://s3.eu-central-1.amazonaws.com/w3coins.io/snapshots/nolus-mainnet/nolus\_snapsot\_latest.tar.lz4)

## State sync

**Stop the node**

```
sudo systemctl stop nolus
```

**Reset the node**

```
cp $HOME/.nolus/data/priv_validator_state.json $HOME/.nolus/priv_validator_state.json.backup
nolus tendermint unsafe-reset-all --home $HOME/.nolus
```

**Get and configure the state sync information**

```
SNAP_RPC="https://nolus-rpc.w3coins.io"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height);
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000));
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash) 
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH && sleep 2
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ;
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ;
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ;
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ;
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.nolus/config/config.toml
```

```
curl https://s3.eu-central-1.amazonaws.com/w3coins.io/wasm/nolus-mainnet/wasmonly.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.nolus
mv $HOME/.nolus/priv_validator_state.json.backup $HOME/.nolus/data/priv_validator_state.json
```

**Restart the node**

```
sudo systemctl restart nolus && sudo journalctl -u nolus -f
```
