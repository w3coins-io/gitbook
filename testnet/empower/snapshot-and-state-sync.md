# Snapshot & State sync

## Snapshot

| Block   | Age     | Download                                                                                                                         |
| ------- | ------- | -------------------------------------------------------------------------------------------------------------------------------- |
|   1892249   |  0 hours | [Snapshot (0.8 GB)](https://s3.eu-central-1.amazonaws.com/w3coins.io/snapshots/empower-testnet/empower_snapsot_latest.tar.lz4)  |

## State sync

**Stop the node**

```
sudo systemctl stop empowerd
```

**Reset the node**

```
cp $HOME/.empowerchain/data/priv_validator_state.json $HOME/.empowerchain/priv_validator_state.json.backup
empowerd tendermint unsafe-reset-all --home $HOME/.empowerchain
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
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.empowerchain/config/config.toml
```

```
curl https://s3.eu-central-1.amazonaws.com/w3coins.io/wasm/empower-testnet/wasmonly.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.empowerchain
mv $HOME/.empowerchain/priv_validator_state.json.backup $HOME/.empowerchain/data/priv_validator_state.json
```

**Restart the node**

```
sudo systemctl restart empowerd && sudo journalctl -u empowerd -f
```
