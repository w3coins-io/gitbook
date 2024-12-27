# Snapshot & State sync

## Snapshot

|     Block   |     Age     |   Download  |
| ----------- | ----------- | ----------- |
|   19528921   |  2 hours | [Snapshot (4.7 GB)](https://s3.eu-central-1.amazonaws.com/w3coins.io/snapshots/akash-mainnet/akash_snapsot_latest.tar.lz4)  |

## State sync

**Stop the node**

```
sudo systemctl stop akash
```

**Reset the node**

```
cp $HOME/.akash/data/priv_validator_state.json $HOME/.akash/priv_validator_state.json.backup
akash tendermint unsafe-reset-all --home $HOME/.akash
```

**Get and configure the state sync information**

```
SNAP_RPC="https://akash-rpc.w3coins.io"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height);
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000));
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash) 
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH && sleep 2
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ;
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ;
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ;
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ;
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.akash/config/config.toml
```

```
mv $HOME/.akash/priv_validator_state.json.backup $HOME/.akash/data/priv_validator_state.json
```

**Restart the node**

```
sudo systemctl restart akash && sudo journalctl -u akash -f
```
