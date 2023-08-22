# Lava Network

**Lava** is a decentralized network of node runners, each incentivized to give you fast, reliable and accurate RPC

### [Stake now!](https://explorer.w3coins.io/LAVA-TESTNET/staking/lava@valoper1tcq6fvmxcyfyfumgd2hrp7ryx49cx6k4vk9nwg)

## **Chain explorer** <a href="#chain-explorer" id="chain-explorer"></a>

* [https://explorer.w3coins.io/LAVA-TESTNET](https://explorer.w3coins.io/LAVA-TESTNET)
* [https://lava.explorers.guru](https://lava.explorers.guru/)

## Community Tools and Services <a href="#community-tools-and-services" id="community-tools-and-services"></a>

#### **RPC**

```
https://lava-testnet-rpc.w3coins.io
```

#### **gRPC**

```
lava-testnet-grpc.w3coins.io:9090
```

#### **API**

```
https://lava-testnet-api.w3coins.io
```

#### **Seed Node**

```
91706fd6ec45e38661ba7bb7567fc572b738c3ea@seed-node.w3coins.io:19966
```

**Addrbook**&#x20;

```
wget -O addrbook.json https://s3.eu-central-1.amazonaws.com/w3coins.io/addrbook/lava-testnet/addrbook.json --inet4-only
mv addrbook.json ~/.lava/config
```

#### **Genesis**

```
wget -O genesis.json https://s3.eu-central-1.amazonaws.com/w3coins.io/genesis/lava-testnet/genesis.json --inet4-only
mv genesis.json ~/.lava/config
```

## Snapshot

Automatic snapshots occur every 24 hours, commencing at 01:30 UTC.

### [Download the latest snapshot.](https://s3.eu-central-1.amazonaws.com/w3coins.io/snapshots/lava-testnet/lava\_snapsot\_latest.tar.lz4)

## State sync

**Stop the node**

```
sudo systemctl stop lavad
```

**Reset the node**

```
cp $HOME/.lava/data/priv_validator_state.json $HOME/.lava/priv_validator_state.json.backup
lavad tendermint unsafe-reset-all --home $HOME/.lava
```

**Get and configure the state sync information**

```
SNAP_RPC="https://lava-testnet-rpc.w3coins.io"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height);
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000));
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash) 
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH && sleep 2
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ;
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ;
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ;
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ;
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.lava/config/config.toml
```

```
mv $HOME/.lava/priv_validator_state.json.backup $HOME/.lava/data/priv_validator_state.json
```

**Restart the node**

```
sudo systemctl restart lavad && sudo journalctl -u lavad -f
```

####
