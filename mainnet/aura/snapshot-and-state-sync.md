# Snapshot & State sync

## Snapshot

| Block   | Age      | Download                                                                                                                         |
| ------- | -------- | -------------------------------------------------------------------------------------------------------------------------------- |
|   3255889   |  18 hour | [Snapshot (0.3 GB)](https://s3.eu-central-1.amazonaws.com/w3coins.io/snapshots/aura-mainnet/aura_snapsot_latest.tar.lz4)  |

## State sync

**Stop the node**

```
sudo systemctl stop aurad
```

**Reset the node**

```
cp $HOME/.aura/data/priv_validator_state.json $HOME/.aura/priv_validator_state.json.backup
aurad tendermint unsafe-reset-all --home $HOME/.aura
```

**Get and configure the state sync information**

```
SNAP_RPC="https://aura-rpc.w3coins.io"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height);
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000));
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash) 
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH && sleep 2
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ;
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ;
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ;
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ;
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.aura/config/config.toml
```

```
curl https://s3.eu-central-1.amazonaws.com/w3coins.io/wasm/aura-mainnet/wasmonly.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.aura
mv $HOME/.aura/priv_validator_state.json.backup $HOME/.aura/data/priv_validator_state.json
```

**Restart the node**

```
sudo systemctl restart aurad && sudo journalctl -u aurad -f
```
