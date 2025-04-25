# Apex prime mainnet relay and core tooling

The `docker-compose-core.yml` file is starting following containers:

* prime-relay (standalone, prerequisite for dbsync)
* ogmios (requires prime-relay)
* postgres (standalone, prerequisite for dbsync)
* dbsync (requires prime-relay and postgres)
* blockfrost (requires dbsync)
* wallet-api (requires prime-relay)
* icarus (requires wallet-api)

The docker compose file is envisioned as example of available tooling and will start all of them in sequence.
Feel free to exclude/modify listed services as per your requirements, following the dependency comments.

The `docker-compose-rosetta.yml` file is starting the following containers:

* rosetta-api (requires prime-relay)
* yaci-indexer (requires prime-relay and postgres)
* submit-api (requires prime-relay)

For details consult the docker compose file but at the time of writing, the following versions apply:

| Component     | Version      | Docker registry                         |
|---------------|--------------|-----------------------------------------|
| prime-relay   |      10.1.4  | ghcr.io/intersectmbo/cardano-node       |
| ogmios        |     v6.10.0  | cardanosolutions/ogmios                 |
| postgres      | 14.10-alpine | postgres                                |
| dbsync        |    13.6.0.4  | ghcr.io/intersectmbo/cardano-db-sync    |
| blockfrost    |      1.7.0   | blockfrost/backend-ryo                  |
| wallet-api    |   2024.9.29  | apexfusion/apex-wallet                  |
| icarus        |  2023-04-14  | piotrstachyra/icarus                    |
| rosetta-api   |       1.2.1  | apexfusion/apex-rosetta-java-api        |
| yaci-indexer  |       1.2.1  | apexfusion/apex-rosetta-java-indexer    |
| submit-api    |      10.1.4  | ghcr.io/intersectmbo/cardano-submit-api |

## Prerequisites:

* intel based linux system (this was tested on)
* docker with compose
* network


## Start procedure

> By default, the `docker-compose-rosetta.yaml` file is commented out.
> In case you want to use it, first copy the `.env.example` to `.env`:
> ```sh
> cp .env.example .env
> ```
> Afterwards, un-comment the `docker-compose-rosetta.yaml` include in the main `docker-compose.yaml` file:
> ```
> ...
> include:
>   - docker-compose-core.yml
>   - docker-compose-rosetta.yml
> ...

Run:

```
docker compose up -d
```


## Apex node relay

This is a relay node connected to a running `prime-mainnet-1014` network. All `cardano-cli` commands apply as usual. For example:

To check the tip (at the moment it is about 10 min to sync, will definitely vary over time):

```
docker exec -it prime-mainnet-1014-prime-relay-1 cardano-cli query tip --mainnet --socket-path /ipc/node.socket
```


## Ogmios API

For ogmios api consult the [online documentation](https://ogmios.dev/api/v6.4/).
To check ogmios http api point a browser to `localhost` port `1337`, for example:

```
http://localhost:1337/
```


## DbSync

DbSync is indexer created as ETL tool coprised of three components:

* running node relay (to track blockchain state)
* dbsync etl tool (to react to block events, parse them and store them to postgres database)
* postgres database

Credentials to access the postgres database are in `secrets/dbsync/` folder.

## Blockfrost

Blockfrost is an instant, highly optimized and accessible API as a Service that serves as an alternative access
to the Cardano blockchain and related networks, with extra features.

For blockfrost api consult the [online documentation](https://docs.blockfrost.io/).
To check the blockfrost point a browser to `localhost` port `3033`, for example:

```
http://localhost:3033
http://localhost:3033/epochs/latest
```

## Wallet API and Icarus

Wallet API provides an HTTP Application Programming Interface (API) and command-line interface (CLI) for
working with wallets. It also featuers a lightweight frontend web interface called Icarus.

For wallet-api consult the [online documentation](https://cardano-foundation.github.io/cardano-wallet/api/edge/).
To check the wallet-api point a browser to `localhost` port `8290`, for example:

```
http://localhost:8290/v2/network/information
http://localhost:8290/v2/network/clock
```

To check the icarus wallet-api ui point a browser to `localhost` port `4477` and then click `Connect` button, for example:

```
http://localhost:4477/
http://localhost:4477/network-info
```

Note that if you are also running a vector testnet compose setup on the same machine you can connect icarus
from either prime or vector setup on either wallet-api by targetting the desired one. Default ports for them are
8190 for prime testnet and 8090 for vector testnet.

# Rosetta API

The [Mesh (formerly Rosetta) API](https://docs.cdp.coinbase.com/mesh/docs/welcome) provides a standardized interface for interacting with blockchain networks. It includes the following components:

Submit API: Handles transaction submissions to the blockchain.
Yaci Indexer: Indexes blockchain data for efficient querying.
API: Provides the Rosetta-compliant API interface.

To check the Rosetta API, send a POST request to localhost port 8082, for example:

```sh
curl -X POST http://localhost:8082/network/status -H "Content-Type: application/json" -d '{"network_identifier": {"blockchain": "prime", "network": "mainnet"}}'
```

For more details about using Rosetta / Mesh API, refer to the [API Reference](https://docs.cdp.coinbase.com/mesh/docs/api-reference)

## Remove procedure

To remove containers and volumes, images will be left for fast restart:

```
docker compose down
docker volume rm \
  prime-mainnet-1014_db-sync-data \
  prime-mainnet-1014_node-db \
  prime-mainnet-1014_postgres \
  prime-mainnet-1014_wallet-api-data
```
