---
description: Agoric NodeM
---

# Validator Setup

**Agoric** is a layer-1 blockchain based on the Cosmos network. The main feature of the project is the ability to create smart contracts with the use of JavaScript. It makes the integration of developers from Web2 to Web3 much easier and expands the ecosystem significantly. Agoric's native token is BLD.

### Minimum hardware requirements: <a href="#nras" id="nras"></a>

* 16 GB RAM
* 4 cores/ vCPU
* 100GB SSD
* Ubuntu 20.04

### **Server preparation:** <a href="#fg1s" id="fg1s"></a>

Before running the node on the server, it's necessary to install Node.js, Yarn, Go and update the system.

**Add a package repository Node.js**

```
curl -Ls https://deb.nodesource.com/setup_16.x | sudo bash
```

**Download the package repository Yarn**

```
curl -Ls https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/yarnkey.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
```

**Update the system and download the building tools**

```
sudo apt -q update
sudo apt -qy install curl git jq lz4 build-essential nodejs=16.* yarn
sudo apt -qy upgrade
```

**Install Go**

```
sudo rm -rf /usr/local/go
curl -Ls https://go.dev/dl/go1.19.9.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
eval $(echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/golang.sh)
eval $(echo 'export PATH=$PATH:$HOME/go/bin' | tee -a $HOME/.profile)
```

### **Node installation:** <a href="#rjfj" id="rjfj"></a>

The node installation process is much easier with the use of previously taken snapshot. We use our variant of snapshot in this guide. You can change ports, seeds, the minimum gas price and the snapshot, if you want.

**Clone the project repository**

```
cd $HOME
rm -rf pismoC
git clone https://github.com/Agoric/agoric-sdk.git pismoC
cd pismoC
git checkout pismoC
```

**Install Agoric Javascript packages**

```
yarn install
yarn build
```

**Integrate Agoric Cosmos SDK support**

```
(cd packages/cosmic-swingset && make)
```

**Prepare binaries for Cosmovisor**

```
mkdir -p $HOME/.agoric/cosmovisor/genesis/bin
ln -s $HOME/pismoC/packages/cosmic-swingset/bin/ag-chain-cosmos $HOME/.agoric/cosmovisor/genesis/bin/ag-chain-cosmos
ln -s $HOME/pismoC/packages/cosmic-swingset/bin/ag-nchainz $HOME/.agoric/cosmovisor/genesis/bin/ag-nchainz
cp golang/cosmos/build/agd $HOME/.agoric/cosmovisor/genesis/bin/
cp golang/cosmos/build/ag-cosmos-helper $HOME/.agoric/cosmovisor/genesis/bin/
```

**Create application symlinks**

```
sudo ln -s $HOME/.agoric/cosmovisor/genesis $HOME/.agoric/cosmovisor/current -f
sudo ln -s $HOME/.agoric/cosmovisor/current/bin/agd /usr/local/bin/agd -f
```

**Download and install Cosmovisor**

```
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.4.0
```

**Create service**

```
sudo tee /etc/systemd/system/agd.service > /dev/null << EOF
[Unit]
Description=agoric node service
After=network-online.target

[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.agoric"
Environment="DAEMON_NAME=agd"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.agoric/cosmovisor/current/bin"

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable agd
```

**Set up node configurations**

```
agd config chain-id agoric-3
agd config keyring-backend file
agd config node tcp://localhost:12757
```

**Initialize the node**

```
agd init NODE_NAME --chain-id agoric-3
```

Instead of NODE\_NAME, enter your name of the node.

**Add the genesis and addrbook files**

```
curl -Ls https://s3.eu-central-1.amazonaws.com/w3coins.io/genesis/agoric-mainnet/genesis.json > $HOME/.agoric/config/genesis.json
curl -Ls https://s3.eu-central-1.amazonaws.com/w3coins.io/addrbook/agoric-mainnet/addrbook.json > $HOME/.agoric/config/addrbook.json
```

**Add seeds**

```
sed -i -e "s|^seeds *=.*|seeds = \"0f04c4610b7511a64b8644944b907416db568590@104.198.182.148:26656\"|" $HOME/.agoric/config/config.toml
```

**Set the minimum gas price**

```
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.03ubld\"|" $HOME/.agoric/config/app.toml
```

**Add custom ports**

```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:12758\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:12757\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:12760\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:12756\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":12766\"%" $HOME/.agoric/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:12717\"%; s%^address = \":8080\"%address = \":12780\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:12790\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:12791\"%; s%:8545%:12745%; s%:8546%:12746%; s%:6065%:12765%" $HOME/.agoric/config/app.toml
```

**Download the snapshot**

```
curl -L https://s3.eu-central-1.amazonaws.com/w3coins.io/snapshots/agoric-mainnet/agoric_snapsot_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.agoric
[[ -f $HOME/.agoric/data/upgrade-info.json ]] && cp $HOME/.agoric/data/upgrade-info.json $HOME/.agoric/cosmovisor/genesis/upgrade-info.json
```

**Run the node**

```
sudo systemctl start agd
```

### Checking and syncing <a href="#t6vi" id="t6vi"></a>

After installation, the node has to be synchronized.

**Check the sync status**

```
agd status | jq .SyncInfo
```

If everything is set up correctly, the response will be something like:

```
{
  "latest_block_hash": "3A0F2AD88C987F6EEDB322BA2CC762A5BC69CF91FB02359DA535D49FFF35CB74",
  "latest_app_hash": "BE512418BDC91AA6BC887F5F33ED2226139D96B5DDB963D2ED4C61BAB4D49F91",
  "latest_block_height": "10123111",
  "latest_block_time": "2023-05-31T13:18:38.478539726Z",
  "earliest_block_hash": "3AB9448D36EF7B2DF224E4721A5BB0EE4182F5CE00B87E78B04E466CF7586568",
  "earliest_app_hash": "64018478AE11A0D2C4262874EE8B65F975DC7CE9720434074AFC25422EACE638",
  "earliest_block_height": "10110283",
  "earliest_block_time": "2023-05-30T16:13:50.226497159Z",
  "catching_up": true
}
```

**Complete sync**

The node is synchronized when "latest\_block\_height" catches up with the last block in the network. At that moment "catching\_up" will change from true to false.

For monitoring, you can use the script:

```
while sleep 5; do
  sync_info=`agd status | jq .SyncInfo`
  echo "$sync_info"
  if test `echo "$sync_info" | jq -r .catching_up` == false; then
    echo "Caught up"
    break
  fi
done
```

When the synchronization is completed, the terminal will say "Caught up"

**Check logs (if errors occur)**

```
journalctl -u agd -f
```

### Key addition. <a href="#sylm" id="sylm"></a>

For further work keys/wallets are necessary.

**Create a new key**

```
agd keys add KEY_NAME
```

Change KEY\_NAME to the name of your key. Add a password and save the mnemonic phrase.

**Add an existing key**

```
agd keys add KEY_NAME --recover
```

**List all keys**

```
agd keys list
```

### **Delegation to the validator**

```
agd tx staking delegate OPERATOR_ADRESS AMOUNT --from KEY_NAME --chain-id agoric-3 --gas-adjustment 1.4 --gas auto --gas-prices 0.03ubld -y
```

Change the following parameters:

\- OPERATOR\_ADRESS - enter the address of the validator, for example, the w3coins address:

```
agoricvaloper1tfmed8ueaxrmdsvkecrae6renyxjct8xwdkes5
```

\- AMOUNT - enter the number of delegated tokens in the ubld value (1BLD = 1000000UBLD), for example:

```
1000000ubld
```

\- KEY\_NAME - enter your key name
