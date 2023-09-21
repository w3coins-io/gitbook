# Snapshot & State sync

## Snapshot

|     Block   |     Age     |   Download  |
| ----------- | ----------- | ----------- |
|   21309978   |  14 hours | [Snapshot (11.6 GB)](https://s3.eu-central-1.amazonaws.com/w3coins.io/snapshots/band-mainnet/band_snapsot_latest.tar.lz4)  |

## State sync

**Stop the node**

```
sudo systemctl stop bandd
```

**Reset the node**

```
cp $HOME/.band/data/priv_validator_state.json $HOME/.band/priv_validator_state.json.backup
bandd tendermint unsafe-reset-all --home $HOME/.band
```

**Get and configure the state sync information**

```
SNAP_RPC="https://band-rpc.w3coins.io"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height);
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000));
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash) 
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH && sleep 2
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ;
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ;
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ;
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ;
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.band/config/config.toml
```

```
mv $HOME/.band/priv_validator_state.json.backup $HOME/.band/data/priv_validator_state.json
```

**Restart the node**

```
sudo systemctl restart bandd && sudo journalctl -u bandd -f
```
