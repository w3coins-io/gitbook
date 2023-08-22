# OJO

**Ojo** is a decentralized security-first oracle network built to support the Cosmos Ecosystem. Ojo will source price data from a diverse catalog of on and off-chain sources and use advanced security mechanisms to guarantee the integrity of the data it provides.

### [Stake now!](https://explorer.w3coins.io/OJO-TESTNET/staking/ojovaloper1rxxe96lvswxjuf3dgdga3d3enep4jacuzw3cuk)

## **Chain explorer**

* [https://explorer.w3coins.io/OJO-TESTNET](https://explorer.w3coins.io/OJO-TESTNET)

## Community Tools and Services <a href="#community-tools-and-services" id="community-tools-and-services"></a>

#### **RPC**

```
https://ojo-testnet-rpc.w3coins.io
```

#### **gRPC**

```
ojo-testnet-grpc.w3coins.io:9990
```

#### **API**

```
https://ojo-testnet-api.w3coins.io
```

#### **Seed Node**

```
91706fd6ec45e38661ba7bb7567fc572b738c3ea@seed-node.w3coins.io:21666
```

#### **Addrbook**&#x20;

```
wget -O addrbook.json https://s3.eu-central-1.amazonaws.com/w3coins.io/addrbook/ojo-testnet/addrbook.json --inet4-only
mv addrbook.json ~/.ojo/config
```

#### **Genesis**

```
wget -O genesis.json https://s3.eu-central-1.amazonaws.com/w3coins.io/genesis/ojo-testnet/genesis.json --inet4-only
mv genesis.json ~/.ojo/config
```

## Snapshot

Automatic snapshots occur every 24 hours, commencing at 01:45 UTC.

### [Download the latest snapshot.](https://s3.eu-central-1.amazonaws.com/w3coins.io/snapshots/ojo-testnet/ojo\_snapsot\_latest.tar.lz4)

## State sync

**Stop the node**

```
sudo systemctl stop ojod
```

**Reset the node**

```
cp $HOME/.ojo/data/priv_validator_state.json $HOME/.ojo/priv_validator_state.json.backup
ojod tendermint unsafe-reset-all --home $HOME/.ojo
```

**Get and configure the state sync information**

```
SNAP_RPC="https://ojo-testnet-rpc.w3coins.io"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height);
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000));
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash) 
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH && sleep 2
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ;
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ;
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ;
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ;
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.ojo/config/config.toml
```

```
mv $HOME/.ojo/priv_validator_state.json.backup $HOME/.ojo/data/priv_validator_state.json
```

**Restart the node**

```
sudo systemctl restart ojod && sudo journalctl -u ojod -f
```
