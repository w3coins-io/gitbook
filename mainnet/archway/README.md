# Archway

_**Archway**_ is the best way for developers to launch decentralized apps (dapps) & smart contracts on a global scale while earning auto-magic rewards.

### [Stake now!](https://explorer.w3coins.io/archway/staking/archwayvaloper1lz9p2lggvnz69dm3gutl3jd9z0gxrhh65j4lrs)  20-23% Expected reward rate

## **Chain explorer**

* [https://explorer.w3coins.io/archway](https://explorer.w3coins.io/archway)
* [https://atomscan.com/archway](https://atomscan.com/archway)
* [https://www.mintscan.io/archway](https://www.mintscan.io/archway)

## Community Tools and Services

#### **RPC**

```
https://archway-rpc.w3coins.io
```

#### **gRPC**

```
archway-grpc.w3coins.io:11590
```

#### **API**

```
https://archway-api.w3coins.io
```

#### **Seed Node**

```
91706fd6ec45e38661ba7bb7567fc572b738c3ea@seed-node.w3coins.io:15556
```

#### **Addrbook**&#x20;

```
wget -O addrbook.json https://s3.eu-central-1.amazonaws.com/w3coins.io/addrbook/archway-mainnet/addrbook.json --inet4-only
mv addrbook.json ~/.archway/config
```

#### **Genesis**

```
wget -O genesis.json https://s3.eu-central-1.amazonaws.com/w3coins.io/genesis/archway-mainnet/genesis.json --inet4-only
mv genesis.json ~/.archway/config
```

## Snapshot

Automatic snapshots occur every 24 hours, commencing at 01:15 UTC.

### [Download the latest snapshot.](https://s3.eu-central-1.amazonaws.com/w3coins.io/snapshots/archway-mainnet/archway\_snapsot\_latest.tar.lz4)

## State sync

**Stop the node**

```
sudo systemctl stop archwayd
```

**Reset the node**

```
cp $HOME/.archway/data/priv_validator_state.json $HOME/.archway/priv_validator_state.json.backup
archwayd tendermint unsafe-reset-all --home $HOME/.archway
```

**Get and configure the state sync information**

```
SNAP_RPC="https://archway-rpc.w3coins.io"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height);
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000));
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash) 
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH && sleep 2
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ;
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ;
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ;
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ;
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.archway/config/config.toml
```

```
curl https://s3.eu-central-1.amazonaws.com/w3coins.io/wasm/archway-mainnet/wasmonly.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.archway
mv $HOME/.archway/priv_validator_state.json.backup $HOME/.archway/data/priv_validator_state.json
```

**Restart the node**

```
sudo systemctl restart archwayd && sudo journalctl -u archwayd -f
```

####
