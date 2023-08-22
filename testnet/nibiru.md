# Nibiru

**Nibiru** is a sovereign proof-of-stake blockchain, open-source platform, and member of a family of interconnected blockchains that comprise the Cosmos Ecosystem.

### [Stake now!](https://explorer.w3coins.io/NIBIRU-TESTNET/staking/nibivaloper1jrrqwjyw02uyx4alncutf34xxyeuq896twk8w0)&#x20;

## **Chain explorer**

* [https://explorer.w3coins.io/NIBIRU-TESTNET](https://explorer.w3coins.io/NIBIRU-TESTNET)
* [https://explorer.nibiru.fi/nibiru-itn-1](https://explorer.nibiru.fi/nibiru-itn-1)
* [https://nibiru.explorers.guru/](https://nibiru.explorers.guru/)

## Community Tools and Services

#### **RPC**

```
https://nibiru-testnet-rpc.w3coins.io
```

#### **gRPC**

```
nibiru-testnet-grpc.w3coins.io:19890
```

#### **API**

```
https://nibiru-testnet-api.w3coins.io
```

#### **Seed Node**

```
91706fd6ec45e38661ba7bb7567fc572b738c3ea@seed-node.w3coins.io:19866
```

#### **Addrbook**&#x20;

```
wget -O addrbook.json https://s3.eu-central-1.amazonaws.com/w3coins.io/addrbook/nibiru-testnet/addrbook.json --inet4-only
mv addrbook.json ~/.nibid/config
```

## Snapshot

Automatic snapshots occur every 24 hours, commencing at 09:00 UTC.

### [Download the latest snapshot](https://s3.eu-central-1.amazonaws.com/w3coins.io/snapshots/nibiru-testnet/nibiru\_snapsot\_latest.tar.lz4).

## State sync

**Stop the node**

```
sudo systemctl stop nibid
```

**Reset the node**

```
cp $HOME/.nibid/data/priv_validator_state.json $HOME/.nibid/priv_validator_state.json.backup
nibid tendermint unsafe-reset-all --home $HOME/.nibid
```

**Get and configure the state sync information**

```
SNAP_RPC="https://nibiru-testnet-rpc.w3coins.io"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height);
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000));
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash) 
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH && sleep 2
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ;
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ;
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ;
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ;
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.nibid/config/config.toml
```

```
curl https://s3.eu-central-1.amazonaws.com/w3coins.io/wasm/nibiru-testnet/wasmonly.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.nibid
mv $HOME/.nibid/priv_validator_state.json.backup $HOME/.nibid/data/priv_validator_state.json
```

**Restart the node**

```
sudo systemctl restart nibid && sudo journalctl -u nibid -f
```

## IBC

Nibiru Chain **<-->** Cosmos Hub

Nibiru Chain **<-->** Osmosis

Nibiru Chain **<-->** Empower Chain

Nibiru Chain **<-->** Stargaze
