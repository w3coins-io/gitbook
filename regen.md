# Regen

**Regen Network** is a global marketplace & contracting platform for Earth's ecosystem assets, services, and data.

### [Stake now!](https://wallet.keplr.app/chains/regen?modal=validator\&chain=regen-1\&validator\_address=regenvaloper139el73jc3jca4atp7rvgc6lupk2na6rqhl4r9f\&referral=true)  20-25% Expected reward rate

### [**Auto-Compound**](https://restake.app/regen/regenvaloper139el73jc3jca4atp7rvgc6lupk2na6rqhl4r9f/stake)  **27-32**% Expected reward rate

{% hint style="info" %}
#### [Auto compound Manual (Restake)](https://youtu.be/XOH161O3C5w)
{% endhint %}

## **Chain explorer**

* [https://explorer.w3coins.io/regen](https://explorer.w3coins.io/regen)
* [https://atomscan.com/regen-network](https://atomscan.com/regen-network)
* [https://www.mintscan.io/regen](https://www.mintscan.io/regen)

## Community Tools and Services

#### **RPC**

```
https://regen-rpc.w3coins.io
```

#### **gRPC**

```
regen-grpc.w3coins.io:22790
```

#### **API**

```
https://regen-api.w3coins.io
```

#### **Seed Node**

```
91706fd6ec45e38661ba7bb7567fc572b738c3ea@seed-node.w3coins.io:23366
```

**Addrbook**

```
wget -O addrbook.json https://s3.eu-central-1.amazonaws.com/w3coins.io/addrbook/regen-mainnet/addrbook.json --inet4-only
mv addrbook.json ~/.regen/config
```

**Genesis**

```
wget -O genesis.json https://s3.eu-central-1.amazonaws.com/w3coins.io/genesis/regen-mainnet/genesis.json --inet4-only
mv genesis.json ~/.regen/config
```

## Snapshot

Automatic snapshots occur every 24 hours, commencing at 04:45 UTC.

### [Download the latest snapshot.](https://s3.eu-central-1.amazonaws.com/w3coins.io/snapshots/regen-mainnet/regen\_snapsot\_latest.tar.lz4)

## State sync

**Stop the node**

```
sudo systemctl stop regen
```

**Reset the node**

```
cp $HOME/.regen/data/priv_validator_state.json $HOME/.regen/priv_validator_state.json.backup
regen tendermint unsafe-reset-all --home $HOME/.regen
```

**Get and configure the state sync information**

```
SNAP_RPC="https://regen-rpc.w3coins.io"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height);
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000));
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash) 
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH && sleep 2
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ;
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ;
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ;
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ;
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.regen/config/config.toml
```

```
mv $HOME/.regen/priv_validator_state.json.backup $HOME/.regen/data/priv_validator_state.json
```

**Restart the node**

```
sudo systemctl restart regen && sudo journalctl -u regen -f
```
