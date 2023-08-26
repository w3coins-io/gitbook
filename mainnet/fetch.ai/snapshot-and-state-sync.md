# Snapshot & State sync

## Snapshot

|     Block   |     Age     |   Download  |
| ----------- | ----------- | ----------- |
|   12619237   |  5 hours | [Snapshot (0.7 GB)](https://s3.eu-central-1.amazonaws.com/w3coins.io/snapshots/fetch-mainnet/fetch_snapsot_latest.tar.lz4)  |

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
