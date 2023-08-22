# Fetch.ai

**Fetch.ai** provides an open infrastructure that enables individuals and businesses to build smart, offline services. Using Fetch.ai technology, users can deploy agents: pieces of code that can create intelligent connections between different systems and devices. This technology allows users to explore new possibilities, from simple AI-driven coordination tasks to complex business logic, and it serves as a platform for discovery and innovation. Fetch.ai creates a parallel digital reflection of the world where autonomous agents can interact with each other to perform useful tasks that businesses can use to optimize their operations, provide offers or discounts to individuals, or analyze sensor data from remote businesses. All of this can happen without human intervention.

### [Stake now!](https://explorer.w3coins.io/fetchhub/staking/fetchvaloper14gtl0dgam6cqvjkuh6kfcnszchwzk0ghumdmhw)  8-10% Expected reward rate

### [**Auto-Compound**](https://restake.app/fetchhub/fetchvaloper14gtl0dgam6cqvjkuh6kfcnszchwzk0ghumdmhw/stake)  **9-11**% Expected reward rate

{% hint style="info" %}
#### [Auto compound Manual (Restake)](https://youtu.be/XOH161O3C5w)
{% endhint %}

## **Chain explorer**

* [https://explorer.w3coins.io/fetchhub](https://explorer.w3coins.io/fetchhub)
* [https://atomscan.com/fetchai](https://atomscan.com/fetchai)
* [https://www.mintscan.io/fetchai](https://www.mintscan.io/fetchai)

## Community Tools and Services

#### **RPC**

```
https://fetch-rpc.w3coins.io
```

#### **gRPC**

```
fetch-grpc.w3coins.io:15290
```

#### **API**

```
https://fetch-api.w3coins.io
```

#### **Seed Node**

```
91706fd6ec45e38661ba7bb7567fc572b738c3ea@seed-node.w3coins.io:15266
```

#### **Addrbook**&#x20;

```
wget -O addrbook.json https://s3.eu-central-1.amazonaws.com/w3coins.io/addrbook/fetch-mainnet/addrbook.json --inet4-only
mv addrbook.json ~/.fetchd/config
```

#### **Genesis**

```
wget -O genesis.json https://s3.eu-central-1.amazonaws.com/w3coins.io/genesis/fetch-mainnet/genesis.json --inet4-only
mv genesis.json ~/.fetchd/config
```

## Snapshot

Automatic snapshots occur every 24 hours, commencing at 06:30 UTC.

### [Download the latest snapshot.](https://s3.eu-central-1.amazonaws.com/w3coins.io/snapshots/fetch-mainnet/fetch\_snapsot\_latest.tar.lz4)

## State sync

**Stop the node**

```
sudo systemctl stop fetch
```

**Reset the node**

```
cp $HOME/.fetchd/data/priv_validator_state.json $HOME/.fetchd/priv_validator_state.json.backup
fetch tendermint unsafe-reset-all --home $HOME/.fetchd
```

**Get and configure the state sync information**

```
SNAP_RPC="https://fetch-rpc.w3coins.io"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height);
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000));
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash) 
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH && sleep 2
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ;
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ;
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ;
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ;
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.fetchd/config/config.toml
```

```
curl https://s3.eu-central-1.amazonaws.com/w3coins.io/wasm/fetch-mainnet/wasmonly.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.fetchd
mv $HOME/.fetchd/priv_validator_state.json.backup $HOME/.fetchd/data/priv_validator_state.json
```

**Restart the node**

```
sudo systemctl restart fetch && sudo journalctl -u fetch -f
```
