# Umee

**Umee** is a layer one blockchain for cross chain communication and interoperability, built on the Cosmos SDK and powered by Tendermint Consensus along with a self sovereign validator network.

### [Stake now!](https://wallet.keplr.app/chains/umee?modal=validator\&chain=umee-1\&validator\_address=umeevaloper1cv2qlz78j5d8fs75lxnystu2lsprvt64yrgfap\&referral=true)  18-24% Expected reward rate

### [**Auto-Compound**](https://restake.app/umee/umeevaloper1cv2qlz78j5d8fs75lxnystu2lsprvt64yrgfap/stake)  **20-26**% Expected reward rate

{% hint style="info" %}
#### [Auto compound Manual (Restake)](https://youtu.be/XOH161O3C5w)
{% endhint %}

## **Chain explorer**

* [https://explorer.w3coins.io/umee](https://explorer.w3coins.io/umee)
* [https://atomscan.com/umee](https://atomscan.com/umee)
* [https://www.mintscan.io/umee](https://www.mintscan.io/umee)

## Community Tools and Services

#### **RPC**

```
https://umee-rpc.w3coins.io
```

#### **gRPC**

```
umee-grpc.w3coins.io:13690
```

#### **API**

```
https://umee-api.w3coins.io
```

#### **Seed Node**

```
91706fd6ec45e38661ba7bb7567fc572b738c3ea@seed-node.w3coins.io:13666
```

#### **Addrbook**

```
wget -O addrbook.json https://s3.eu-central-1.amazonaws.com/w3coins.io/addrbook/umee-mainnet/addrbook.json --inet4-only
mv addrbook.json ~/.umee/config
```

## Snapshot

Automatic snapshots occur every 24 hours, commencing at 02:00 UTC.

### [Download the latest snapshot.](https://s3.eu-central-1.amazonaws.com/w3coins.io/snapshots/umee-mainnet/umee\_snapsot\_latest.tar.lz4)

## State sync

**Stop the node**

```
sudo systemctl stop umeed
```

**Reset the node**

```
cp $HOME/.umee/data/priv_validator_state.json $HOME/.umee/priv_validator_state.json.backup
umeed tendermint unsafe-reset-all --home $HOME/.umee
```

**Get and configure the state sync information**

```
SNAP_RPC="http://umee-rpc.w3coins.io:13657"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height);
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000));
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash) 
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH && sleep 2
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ;
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ;
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ;
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ;
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.umee/config/config.toml
```

```
mv $HOME/.umee/priv_validator_state.json.backup $HOME/.umee/data/priv_validator_state.json
```

**Restart the node**

```
sudo systemctl restart umeed && sudo journalctl -u umeed -f
```
