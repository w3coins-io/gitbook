# OKP4

_**OKP4**_ is the only public layer-1 _blockchain_ designed for coordination of digital assets such as datasets, algorithms, software, storage or computation.

### [Stake now!](https://explorer.w3coins.io/OKP4-TESTNET/staking/okp4valoper1tv3z8z8ptrteuym5vexagxpa90tjp7u4l0qhq9)

## **Chain explorer**

* [https://explorer.w3coins.io/OKP4-TESTNET](https://explorer.w3coins.io/OKP4-TESTNET)

## Community Tools and Services <a href="#community-tools-and-services" id="community-tools-and-services"></a>

#### **RPC**

```
https://okp4-testnet-rpc.w3coins.io
```

#### **gRPC**

```
okp4-testnet-grpc.w3coins.io:9980
```

#### **API**

```
https://okp4-testnet-api.w3coins.io
```

#### **Seed Node**

```
91706fd6ec45e38661ba7bb7567fc572b738c3ea@seed-node.w3coins.io:17666
```

#### **Addrbook**&#x20;

```
wget -O addrbook.json https://s3.eu-central-1.amazonaws.com/w3coins.io/addrbook/okp4-testnet/addrbook.json --inet4-only
mv addrbook.json ~/.okp4d/config
```

#### **Genesis**

```
wget -O genesis.json https://s3.eu-central-1.amazonaws.com/w3coins.io/genesis/okp4-testnet/genesis.json --inet4-only
mv genesis.json ~/.okp4d/config
```

## Snapshot

Automatic snapshots occur every 24 hours, commencing at 05:30 UTC.

### [Download the latest snapshot](https://s3.eu-central-1.amazonaws.com/w3coins.io/snapshots/okp4-testnet/okp4\_snapsot\_latest.tar.lz4).

## State sync

**Stop the node**

```
sudo systemctl stop okp4
```

**Reset the node**

```
cp $HOME/.okp4d/data/priv_validator_state.json $HOME/.okp4d/priv_validator_state.json.backup
okp4 tendermint unsafe-reset-all --home $HOME/.okp4d
```

**Get and configure the state sync information**

```
SNAP_RPC="https://okp4-testnet-rpc.w3coins.io"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height);
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000));
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash) 
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH && sleep 2
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ;
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ;
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ;
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ;
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.okp4d/config/config.toml
```

```
curl https://s3.eu-central-1.amazonaws.com/w3coins.io/wasm/okp4-testnet/wasmonly.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.okp4d
mv $HOME/.okp4d/priv_validator_state.json.backup $HOME/.okp4d/data/priv_validator_state.json
```

**Restart the node**

```
sudo systemctl restart okp4 && sudo journalctl -u okp4 -f
```
