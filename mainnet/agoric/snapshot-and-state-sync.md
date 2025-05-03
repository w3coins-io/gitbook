# Snapshot & State sync

## Snapshot

| Block    | Age     | Download                                                                                                                       |
| -------- | ------- | ------------------------------------------------------------------------------------------------------------------------------ |
|   19466373   |  19 hours | [Snapshot (34.1 GB)](https://s3.eu-central-1.amazonaws.com/w3coins.io/snapshots/agoric-mainnet/agoric_snapsot_latest.tar.lz4)  |

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
SNAP_RPC="https://agoric-api.w3coins.io"
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
