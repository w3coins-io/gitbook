# Snapshot & State sync

## Snapshot

|     Block   |     Age     |   Download  |
| ----------- | ----------- | ----------- |
|   51622509   |  21 hours | [Snapshot (13.0 GB)](https://s3.eu-central-1.amazonaws.com/w3coins.io/snapshots/injective-mainnet/injective_snapsot_latest.tar.lz4)  |

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
