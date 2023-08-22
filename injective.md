# Injective

**Injective** is financial system through decentralization. With the blockchain built for finance, and plug-and-play Web3 modules. Injective’s ecosystem is interoperable, scalable, and decentralized.

### [Stake now!](https://wallet.keplr.app/chains/injective?modal=validator\&chain=injective-1\&validator\_address=injvaloper1tly62qxj2t8wz2zw4d7p37jcysvgasqa0zjtlk\&referral=true)  15-17% Expected reward rate

### [**Auto-Compound**](https://restake.app/injective/injvaloper1tly62qxj2t8wz2zw4d7p37jcysvgasqa0zjtlk/stake)  **16-19**% Expected reward rate

{% hint style="info" %}
#### [Auto compound Manual (Restake)](https://youtu.be/XOH161O3C5w)
{% endhint %}

## **Chain explorer**

* [https://explorer.w3coins.io/injective](https://explorer.w3coins.io/injective)
* [https://atomscan.com/injective](https://atomscan.com/injective)
* [https://www.mintscan.io/injective](https://www.mintscan.io/injective)

## Community Tools and Services

#### **RPC**

```
https://injective-rpc.w3coins.io
```

#### **gRPC**

```
injective-grpc.w3coins.io:14390
```

#### **API**

```
https://injective-api.w3coins.io
```

#### **Seed Node**

```
91706fd6ec45e38661ba7bb7567fc572b738c3ea@seed-node.w3coins.io:14266
```

**Addrbook**

```
wget -O addrbook.json https://s3.eu-central-1.amazonaws.com/w3coins.io/addrbook/injective-mainnet/addrbook.json --inet4-only
mv addrbook.json ~/.injectived/config
```

**Genesis**

```
wget -O genesis.json https://s3.eu-central-1.amazonaws.com/w3coins.io/genesis/injective-mainnet/genesis.json --inet4-only
mv genesis.json ~/.injectived/config
```

## Snapshot

Automatic snapshots occur every 24 hours, commencing at 04:00 UTC.

### [Download the latest snapshot.](https://s3.eu-central-1.amazonaws.com/w3coins.io/snapshots/injective-mainnet/injective\_snapsot\_latest.tar.lz4)

## State sync

**Stop the node**

```
sudo systemctl stop injective
```

**Reset the node**

```
cp $HOME/.injectived/data/priv_validator_state.json $HOME/.injectived/priv_validator_state.json.backup
injective tendermint unsafe-reset-all --home $HOME/.injectived
```

**Get and configure the state sync information**

```
SNAP_RPC="https://injective-rpc.w3coins.io"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height);
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000));
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash) 
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH && sleep 2
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ;
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ;
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ;
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ;
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.injectived/config/config.toml
```

```
curl https://s3.eu-central-1.amazonaws.com/w3coins.io/wasm/injective-mainnet/wasmonly.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.injectived
mv $HOME/.injectived/priv_validator_state.json.backup $HOME/.injectived/data/priv_validator_state.json
```

**Restart the node**

```
sudo systemctl restart injective && sudo journalctl -u injective -f
```
