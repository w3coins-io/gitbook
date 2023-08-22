# Agoric

**Agoric** is a layer-1 blockchain based on the Cosmos network. The main feature of the project is the ability to create smart contracts with the use of JavaScript. It makes the integration of developers from Web2 to Web3 much easier and expands the ecosystem significantly. Agoric's native token is BLD.

### [Stake now! ](https://wallet.keplr.app/chains/agoric?modal=validator\&chain=agoric-3\&validator\_address=agoricvaloper1tfmed8ueaxrmdsvkecrae6renyxjct8xwdkes5\&referral=true) 9-11% Expected reward rate

### [**Auto-Compound**](https://restake.app/agoric/agoricvaloper1tfmed8ueaxrmdsvkecrae6renyxjct8xwdkes5/stake)  **10-12**% Expected reward rate

## **Chain explorer**

* [https://explorer.w3coins.io/agoric](https://explorer.w3coins.io/agoric)
* [https://atomscan.com/agoric](https://atomscan.com/agoric)
* [https://agoric.explorers.guru/](https://agoric.explorers.guru/)

## Community Tools and Services

#### **RPC**

```
https://agoric-rpc.w3coins.io
```

#### **gRPC**

```
agoric-grpc.w3coins.io:14490
```

#### **API**

```
https://agoric-api.w3coins.io
```

#### **Seed Node**

```
91706fd6ec45e38661ba7bb7567fc572b738c3ea@seed-node.w3coins.io:14366
```

**Addrbook**

```
wget -O addrbook.json https://s3.eu-central-1.amazonaws.com/w3coins.io/addrbook/agoric-mainnet/addrbook.json --inet4-only
mv addrbook.json ~/.agoric/config
```

**Genesis**

```
wget -O genesis.json https://s3.eu-central-1.amazonaws.com/w3coins.io/genesis/agoric-mainnet/genesis.json --inet4-only
mv genesis.json ~/.agoric/config
```

## Snapshot

Automatic snapshots occur every 24 hours, commencing at 04:30 UTC.

### [Download the latest snapshot.](https://s3.eu-central-1.amazonaws.com/w3coins.io/snapshots/agoric-mainnet/agoric\_snapsot\_latest.tar.lz4)

## State sync

**Stop the node**

```
sudo systemctl stop agd
```

**Reset the node**

```
cp $HOME/.agoric/data/priv_validator_state.json $HOME/.agoric/priv_validator_state.json.backup
agd tendermint unsafe-reset-all --home $HOME/.agoric
```

**Get and configure the state sync information**

```
SNAP_RPC="https://empower-testnet-rpc.w3coins.io:443"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height);
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000));
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash) 
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH && sleep 2
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ;
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ;
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ;
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ;
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.agoric/config/config.toml
```

```
mv $HOME/.agoric/priv_validator_state.json.backup $HOME/.agoric/data/priv_validator_state.json
```

**Restart the node**

```
sudo systemctl restart agd && sudo journalctl -u agd -f
```
