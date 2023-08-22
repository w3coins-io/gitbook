# Akash

**Akash Network** is a decentralized cloud marketplace where tenants purchase cloud-grade compute in an open market from providers in a permissionless manner. The network is maintained by a network of validators and governed by AKT stakers.

### [Stake now!](https://wallet.keplr.app/chains/akash?modal=validator\&chain=akashnet-2\&validator\_address=akashvaloper14jz04wwvwkpjzezq8zvrl5yv4qq3p5lqct7plh\&referral=true)  9-11% Expected reward rate

### [**Auto-Compound** ](https://restake.app/akash/akashvaloper14jz04wwvwkpjzezq8zvrl5yv4qq3p5lqct7plh/stake) **10-12**% Expected reward rate

{% hint style="info" %}
#### [Auto compound Manual (Restake)](https://youtu.be/XOH161O3C5w)
{% endhint %}

## **Chain explorer**

* [https://explorer.w3coins.io/akash](https://explorer.w3coins.io/akash)
* [https://atomscan.com/akash](https://atomscan.com/akash)
* [https://www.mintscan.io/akash](https://www.mintscan.io/akash)



## Community Tools and Services

#### **RPC**

```
https://akash-rpc.w3coins.io
```

#### **gRPC**

```
akash-grpc.w3coins.io:12890
```

#### **API**

```
https://akash-api.w3coins.io
```

#### **Seed Node**

```
91706fd6ec45e38661ba7bb7567fc572b738c3ea@seed-node.w3coins.io:12866
```

#### **Addrbook**&#x20;

```
wget -O addrbook.json https://s3.eu-central-1.amazonaws.com/w3coins.io/addrbook/akash-mainnet/addrbook.json --inet4-only
mv addrbook.json ~/.akash/config
```

#### **Genesis**

```
wget -O genesis.json https://s3.eu-central-1.amazonaws.com/w3coins.io/genesis/akash-mainnet/genesis.json --inet4-only
mv genesis.json ~/.akash/config
```

## Snapshot

Automatic snapshots occur every 24 hours, commencing at 00:30 UTC.

### [Download the latest snapshot.](https://s3.eu-central-1.amazonaws.com/w3coins.io/snapshots/akash-mainnet/akash\_snapsot\_latest.tar.lz4)

## State sync

**Stop the node**

```
sudo systemctl stop akash
```

**Reset the node**

```
cp $HOME/.akash/data/priv_validator_state.json $HOME/.akash/priv_validator_state.json.backup
akash tendermint unsafe-reset-all --home $HOME/.akash
```

**Get and configure the state sync information**

```
SNAP_RPC="https://akash-rpc.w3coins.io"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height);
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000));
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash) 
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH && sleep 2
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ;
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ;
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ;
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ;
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.akash/config/config.toml
```

```
mv $HOME/.akash/priv_validator_state.json.backup $HOME/.akash/data/priv_validator_state.json
```

**Restart the node**

```
sudo systemctl restart akash && sudo journalctl -u akash -f
```

####
