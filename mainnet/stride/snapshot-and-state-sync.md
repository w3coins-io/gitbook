# Snapshot & State sync

## Snapshot

|     Block   |     Age     |   Download  |
| ----------- | ----------- | ----------- |
|   5147060   |  4 hours | [Snapshot (2.4 GB)](https://s3.eu-central-1.amazonaws.com/w3coins.io/snapshots/stride-mainnet/stride_snapsot_latest.tar.lz4)  |

## State sync

**Stop the node**

```
sudo systemctl stop strided
```

**Reset the node**

```
cp $HOME/.stride/data/priv_validator_state.json $HOME/.stride/priv_validator_state.json.backup
strided tendermint unsafe-reset-all --home $HOME/.stride
```

**Get and configure the state sync information**

```
SNAP_RPC="http://stride-rpc.w3coins.io:12257"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height);
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000));
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash) 
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH && sleep 2
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ;
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ;
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ;
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ;
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.stride/config/config.toml
```

```
mv $HOME/.stride/priv_validator_state.json.backup $HOME/.stride/data/priv_validator_state.json
```

**Restart the node**

```
sudo systemctl restart strided && sudo journalctl -u strided -f
```
