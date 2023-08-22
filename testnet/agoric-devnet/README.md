# Agoric - Devnet

**Agoric** is a layer-1 blockchain based on the Cosmos network. The main feature of the project is the ability to create smart contracts with the use of JavaScript. It makes the integration of developers from Web2 to Web3 much easier and expands the ecosystem significantly. Agoric's native token is BLD.

### [Stake now!](https://explorer.w3coins.io/AGORIC-DEVNET/staking/agoricvaloper12hpugytp9rkdzs4wry9z2n42qrea5cmlje7ck0)

## **Chain explorer**

* [https://explorer.w3coins.io/AGORIC-DEVNET](https://explorer.w3coins.io/AGORIC-DEVNET)

#### **RPC**

```
https://agoric-devnet-rpc.w3coins.io
```

#### **gRPC**

```
agoric-devnet-grpc:9970
```

#### **API**

```
https://agoric-devnet-api.w3coins.io
```

#### **Seed Node**

```
91706fd6ec45e38661ba7bb7567fc572b738c3ea@seed-node.w3coins.io:14466
```

**Addrbook**

```
wget -O addrbook.json https://s3.eu-central-1.amazonaws.com/w3coins.io/addrbook/agoric-testnet/addrbook.json --inet4-only
mv addrbook.json ~/.agoric/config
```

**Genesis**

```
wget -O genesis.json https://s3.eu-central-1.amazonaws.com/w3coins.io/genesis/agoric-testnet/genesis.json --inet4-only
mv genesis.json ~/.agoric/config
```

## Snapshot

Automatic snapshots occur every 24 hours, commencing at 03:30 UTC.

### [Download the latest snapshot.](https://s3.eu-central-1.amazonaws.com/w3coins.io/snapshots/agoric-testnet/agoric\_snapsot\_latest.tar.lz4)

## State sync

**Stop the node**

```
sudo systemctl stop agd
```

**Reset the node**

```
cp $HOME/.agoric/data/priv_validator_state.json $HOME/.agoric/priv_validator_state.json.backup
agd tendermint unsafe-reset-all --home $HOME/.agoric
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
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.agoric/config/config.toml
```

```
mv $HOME/.agoric/priv_validator_state.json.backup $HOME/.agoric/data/priv_validator_state.json
```

**Restart the node**

```
sudo systemctl restart agd && sudo journalctl -u agd -f
```
