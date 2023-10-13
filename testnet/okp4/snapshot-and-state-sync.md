# Snapshot & State sync

## Snapshot

| Block   | Age     | Download                                                                                                                   |
| ------- | ------- | -------------------------------------------------------------------------------------------------------------------------- |
|   4561801   |  12 hours | [Snapshot (0.9 GB)](https://s3.eu-central-1.amazonaws.com/w3coins.io/snapshots/okp4-testnet/okp4_snapsot_latest.tar.lz4)  |

## State sync

**Stop the node**

```
sudo systemctl stop okp4
```

**Reset the node**

```
cp $HOME/.okp4d/data/priv_validator_state.json $HOME/.okp4d/priv_validator_state.json.backup
okp4 tendermint unsafe-reset-all --home $HOME/.okp4d
```

**Get and configure the state sync information**

```
SNAP_RPC="https://okp4-testnet-rpc.w3coins.io"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height);
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000));
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash) 
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH && sleep 2
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ;
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ;
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ;
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ;
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.okp4d/config/config.toml
```

```
curl https://s3.eu-central-1.amazonaws.com/w3coins.io/wasm/okp4-testnet/wasmonly.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.okp4d
mv $HOME/.okp4d/priv_validator_state.json.backup $HOME/.okp4d/data/priv_validator_state.json
```

**Restart the node**

```
sudo systemctl restart okp4 && sudo journalctl -u okp4 -f
```
