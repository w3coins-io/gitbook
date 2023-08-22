# Band

**Band** cross-chain data oracle platform that aggregates and connects real-world data and APIs to smart contracts.

### [Stake now!](https://explorer.w3coins.io/band/staking/bandvaloper1hdw8pzr79y4at0teak0mwcrjhv3e6n3wegfv2m)  10-12% Expected reward rate

### [**Auto-Compound**](https://restake.app/bandchain/bandvaloper1hdw8pzr79y4at0teak0mwcrjhv3e6n3wegfv2m/stake)  **11-13**% Expected reward rate

{% hint style="info" %}
#### [Auto compound Manual (Restake)](https://youtu.be/XOH161O3C5w)
{% endhint %}

## **Chain explorer**

* [https://explorer.w3coins.io/band](https://explorer.w3coins.io/band)
* [https://www.mintscan.io/band](https://www.mintscan.io/band)
* [https://atomscan.com/band-protocol](https://atomscan.com/band-protocol)

## Community Tools and Services

#### **RPC**

```
https://band-rpc.w3coins.io
```

#### **gRPC**

```
band-grpc.w3coins.io:22990
```

#### **API**

```
https://band-api.w3coins.io
```

#### **Seed Node**

```
91706fd6ec45e38661ba7bb7567fc572b738c3ea@seed-node.w3coins.io:22966
```

**Addrbook**&#x20;

```
wget -O addrbook.json https://s3.eu-central-1.amazonaws.com/w3coins.io/addrbook/band-mainnet/addrbook.json --inet4-only
mv addrbook.json ~/.band/config
```

#### **Genesis**

```
wget -O genesis.json https://s3.eu-central-1.amazonaws.com/w3coins.io/genesis/band-mainnet/genesis.json --inet4-only
mv genesis.json ~/.band/config
```

## Snapshot

Automatic snapshots occur every 24 hours, commencing at 00:45 UTC.

### [Download the latest snapshot.](https://s3.eu-central-1.amazonaws.com/w3coins.io/snapshots/band-mainnet/band\_snapsot\_latest.tar.lz4)

## State sync

**Stop the node**

```
sudo systemctl stop bandd
```

**Reset the node**

```
cp $HOME/.band/data/priv_validator_state.json $HOME/.band/priv_validator_state.json.backup
bandd tendermint unsafe-reset-all --home $HOME/.band
```

**Get and configure the state sync information**

```
SNAP_RPC="https://band-rpc.w3coins.io"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height);
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000));
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash) 
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH && sleep 2
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ;
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ;
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ;
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ;
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.band/config/config.toml
```

```
mv $HOME/.band/priv_validator_state.json.backup $HOME/.band/data/priv_validator_state.json
```

**Restart the node**

```
sudo systemctl restart bandd && sudo journalctl -u bandd -f
```

####
