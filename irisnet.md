# IRISnet

**IRISnet** is designed to be the foundation for the next generation distributed applications. Built with Cosmos-SDK, IRIS Hub enables cross-chain interoperability through a unified service model, while providing a variety of modules to support DeFi applications.

### [Stake now!](https://wallet.keplr.app/chains/irisnet?modal=validator\&chain=irishub-1\&validator\_address=iva18x27mzk6xchwynyqa35hrknfwxet82ass5987a\&referral=true)  8-11% Expected reward rate

### [**Auto-Compound**](https://restake.app/irisnet/iva18x27mzk6xchwynyqa35hrknfwxet82ass5987a/stake)  **9-12**% Expected reward rate

{% hint style="info" %}
#### [Auto compound Manual (Restake)](https://youtu.be/XOH161O3C5w)
{% endhint %}

## **Chain explorer**

* [https://explorer.w3coins.io/iris](https://explorer.w3coins.io/iris)
* [https://atomscan.com/iris-network](https://atomscan.com/iris-network)
* [https://www.mintscan.io/iris](https://www.mintscan.io/iris)

## Community Tools and Services

#### **RPC**

```
https://irisnet-rpc.w3coins.io
```

#### **gRPC**

```
irisnet-grpc.w3coins.io:22690
```

#### **API**

```
https://irisnet-api.w3coins.io
```

#### **Seed Node**

```
91706fd6ec45e38661ba7bb7567fc572b738c3ea@seed-node.w3coins.io:23166
```

**Addrbook**

```
wget -O addrbook.json https://s3.eu-central-1.amazonaws.com/w3coins.io/addrbook/iris-mainnet/addrbook.json --inet4-only
mv addrbook.json ~/.iris/config
```

**Genesis**

```
wget -O genesis.json https://s3.eu-central-1.amazonaws.com/w3coins.io/genesis/iris-mainnet/genesis.json --inet4-only
mv genesis.json ~/.iris/config
```

## Snapshot

Automatic snapshots occur every 24 hours, commencing at 01:45 UTC.

### [Download the latest snapshot.](https://s3.eu-central-1.amazonaws.com/w3coins.io/snapshots/iris-mainnet/iris\_snapsot\_latest.tar.lz4)

## State sync

**Stop the node**

```
sudo systemctl stop iris
```

**Reset the node**

```
cp $HOME/.iris/data/priv_validator_state.json $HOME/.iris/priv_validator_state.json.backup
iris tendermint unsafe-reset-all --home $HOME/.iris
```

**Get and configure the state sync information**

```
SNAP_RPC="https://irisnet-rpc.w3coins.io"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height);
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000));
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash) 
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH && sleep 2
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ;
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ;
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ;
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ;
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.iris/config/config.toml
```

```
mv $HOME/.iris/priv_validator_state.json.backup $HOME/.iris/data/priv_validator_state.json
```

**Restart the node**

```
sudo systemctl restart iris && sudo journalctl -u iris -f
```
