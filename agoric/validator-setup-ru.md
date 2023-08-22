---
description: Нода Agoric
---

# Validator Setup Ru

_**Agoric** - блокчейн первого уровня построенный на базе системы Cosmos. Особенностью проекта является возможность создания смарт-контрактов на языке JavaScript, что позволяет легко интегрировать разработчиков с Web2 в Web3 и быстро расширять экосистему. Нативный токен Agoric - BLD._

### **Минимальные требования:**

* 16 GB RAM
* 4 cores/ vCPU
* 100 GB SSD
* Ubuntu 20.04

### **Подготовка сервера:**

Перед установкой ноды на сервер необходимо установить Node.js, Yarn, Go и обновить систему.

**Добавляем репозиторий пакетов Node.js**

```
curl -Ls https://deb.nodesource.com/setup_16.x | sudo bash
```

**Загружаем репозиторий пакетов Yarn**

```
curl -Ls https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/yarnkey.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
```

**Обновляем систему и загружаем необходимые инструменты**

```
sudo apt -q update
sudo apt -qy install curl git jq lz4 build-essential nodejs=16.* yarn
sudo apt -qy upgrade
```

**Устанавливаем Go**

```
sudo rm -rf /usr/local/go
curl -Ls https://go.dev/dl/go1.19.9.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
eval $(echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/golang.sh)
eval $(echo 'export PATH=$PATH:$HOME/go/bin' | tee -a $HOME/.profile)
```

### **Установка ноды:** <a href="#zygv" id="zygv"></a>

Установка ноды происходить при помощи сделанного ранее снимка. При желании или необходимости порты, сиды, минимальную цену газа и сами снимки можно заменить на собственные или общедоступные.

**Клонируем репозиторий проекта**

```
cd $HOME
rm -rf pismoC
git clone https://github.com/Agoric/agoric-sdk.git pismoC
cd pismoC
git checkout pismoC
```

**Устанавливаем Agoric Javascript пакеты**

```
yarn install
yarn build
```

**Интегрируем поддержку Agoric Cosmos SDK**

```
(cd packages/cosmic-swingset && make)
```

**Подготавливаем файлы для Cosmovisor**

```
mkdir -p $HOME/.agoric/cosmovisor/genesis/bin
ln -s $HOME/pismoC/packages/cosmic-swingset/bin/ag-chain-cosmos $HOME/.agoric/cosmovisor/genesis/bin/ag-chain-cosmos
ln -s $HOME/pismoC/packages/cosmic-swingset/bin/ag-nchainz $HOME/.agoric/cosmovisor/genesis/bin/ag-nchainz
cp golang/cosmos/build/agd $HOME/.agoric/cosmovisor/genesis/bin/
cp golang/cosmos/build/ag-cosmos-helper $HOME/.agoric/cosmovisor/genesis/bin/
```

**Создаем ссылки**

```
sudo ln -s $HOME/.agoric/cosmovisor/genesis $HOME/.agoric/cosmovisor/current -f
sudo ln -s $HOME/.agoric/cosmovisor/current/bin/agd /usr/local/bin/agd -f
```

**Загружаем и устанавливаем Cosmovisor**

```
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.4.0
```

**Создаем сервис для запуска**

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

**Настраиваем конфигурации ноды**

```
agd config chain-id agoric-3
agd config keyring-backend file
agd config node tcp://localhost:12757
```

**Инициализируем ноду**

```
agd init NODE_NAME --chain-id agoric-3
```

Вместо NODE\_NAME вписываем название ноды

**Загружаем файлы genesis и addrbook**

```
curl -Ls https://s3.eu-central-1.amazonaws.com/w3coins.io/genesis/agoric-mainnet/genesis.json > $HOME/.agoric/config/genesis.json
curl -Ls https://s3.eu-central-1.amazonaws.com/w3coins.io/addrbook/agoric-mainnet/addrbook.json > $HOME/.agoric/config/addrbook.json
```

**Добавляем сиды**

```
sed -i -e "s|^seeds *=.*|seeds = \"0f04c4610b7511a64b8644944b907416db568590@104.198.182.148:26656\"|" $HOME/.agoric/config/config.toml
```

**Устанавливаем минимальную цену газа**

```
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.03ubld\"|" $HOME/.agoric/config/app.toml
```

**Добавляем альтернативные порты**

```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:12758\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:12757\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:12760\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:12756\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":12766\"%" $HOME/.agoric/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:12717\"%; s%^address = \":8080\"%address = \":12780\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:12790\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:12791\"%; s%:8545%:12745%; s%:8546%:12746%; s%:6065%:12765%" $HOME/.agoric/config/app.toml
```

**Загружаем снимок сети**

```
curl -L https://s3.eu-central-1.amazonaws.com/w3coins.io/snapshots/agoric-mainnet/agoric_snapsot_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.agoric
[[ -f $HOME/.agoric/data/upgrade-info.json ]] && cp $HOME/.agoric/data/upgrade-info.json $HOME/.agoric/cosmovisor/genesis/upgrade-info.json
```

**Запускаем ноду**

```
sudo systemctl start agd
```

### Проверка и синхронизация <a href="#6ojr" id="6ojr"></a>

После установки ноде необходимо синхронизироваться.

**Проверяем статус синхронизации**

```
agd status | jq .SyncInfo
```

Если все установлено правильно, ответ будет подобным:

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

**Конец синхронизации**

Нода синхронизирована, когда "latest\_block\_height" догонит последний блок в сети. В тот момент "catching\_up" сменится с true на false.

Для монтиринга можно использовать скрипт:

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

По завершению синхронизации в терминале будет написано "Caught up"

**Проверка логов (при возникновении ошибок)**

```
journalctl -u agd -f
```

### Добавление ключа <a href="#3cxg" id="3cxg"></a>

Для дальнейшей работы необходимо добавить ключи/кошельки.

**Создание нового ключа**

```
agd keys add KEY_NAME
```

Меняем KEY\_NAME на название вашего ключа. Добавляем пароль и сохраняем мнемоническую фразу.

**Добавление имеющегося ключа**

```
agd keys add KEY_NAME --recover
```

**Проверка ключей**

```
agd keys list
```

### **Делегация валидатору**

```
agd tx staking delegate OPERATOR_ADRESS AMOUNT --from KEY_NAME --chain-id agoric-3 --gas-adjustment 1.4 --gas auto --gas-prices 0.03ubld -y
```

Изменяем следующие параметры:

\- OPERATOR\_ADRESS - вписываем адрес валидатора, например адрес w3coins:

```
agoricvaloper1tfmed8ueaxrmdsvkecrae6renyxjct8xwdkes5
```

\- AMOUNT - вписываем количество делегируемых токенов в значении ubld (1BLD = 1000000UBLD), например:

```
1000000ubld
```

\- KEY\_NAME - вписываем раннее указанное имя ключа
