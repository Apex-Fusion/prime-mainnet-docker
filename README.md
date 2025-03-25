# Apex prime relay and tooling repository

This repository contains docker compose setup to launch apex prime network components.

Notes:

* There are multiple versions of tool sets used, see the below table for details.
* Secrets stored in the respository (database access credentials) are for example purposes only and should
*NOT* be used in any real scenario unaltered. They are set only for completeness so that a local setup can
be spun up directly.
* Full set of genesis, topology and configuration files are within each tool version subfolders.
* Details for each of the versions of the tool sets are in separate README.md files in appropriate subfolders.


# Versions of the tool sets

For detals consult the docker compose file but at the time of writing, the followinge versions apply:

| Network | Folder     | prime-relay | ogmios | db-sync  | postgres     | blockfrost |  wallet-api  |   icarus   |
|---------|------------|-------------|--------|----------|--------------|------------|--------------|------------|
| mainnet | node-10.1.4 |    10.1.4    | v6.10.0 | 13.6.0.4 | 14.10-alpine |    1.7.0   |  2024.9.29  | 2024-03-25 |


Docker compose file is starting following containers:

* prime-relay (standalone, prerequisite for dbsync)
* ogmios (requires prime-relay)
* postgres (standalone, prerequisite for dbsync)
* dbsync (requires prime-relay and postgres)

The docker compose file is envisioned as example of available tooling and will start all of them in sequence.
Feel free to exclude/modify listed services as per your requirements, following the dependency comments.


## Prerequisites:

* intel based linux system (this was tested on, will most likely work on other platforms as well)
* docker with compose
* network


## Start procedure

Run:

```
docker compose up -d
```


## Apex node relay

This is a relay node connected to a running `prime-mainnet` network. All `cardano-cli` commands apply as usual.

For more details consult the `README.md` file from the tool version folder that compose was started from.


## Ogmios API

For ogmios api consult the [online documentation](https://ogmios.dev/api/v6.8/).

To check ogmios http api point a browser to `localhost` port `1337`, for example:

```
http://localhost:1337/
```


## DbSync

DbSync is indexer created as ETL tool coprised of three components:

* running node relay (to track blockchain state)
* dbsync etl tool (to react to block events, parse them and store them to postgres database)
* postgres database

Credentials to access the postgres database are in `secrets/dbsync/` folder. They are example credentials
and are *NOT* to be used unaltered in any settings other than a local ephemeral test.


## Remove procedure

To remove containers and volumes, consult the `README.md` file in actual tool folder that compose was started from
