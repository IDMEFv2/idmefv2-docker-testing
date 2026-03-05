# IDMEFv2 docker testing: T-Pot + IDMEFv2 connector

## ⚠️ Important Requirements (Read First)

This test environment is based on a streamlined version of T-Pot. While it is significantly lighter than a full production deployment, it still has specific requirements to function correctly.

### 1. Infrastructure & Virtualization

**Dedicated VM (Strongly Recommended):** For maximum realism, running on a dedicated VM is preferred. T-Pot components are designed to capture "real-world" attack traffic, which often targets standard system ports.

**Shared Host (Possible):** Unlike a full T-Pot installation, this reduced stack can run on a shared host if you are careful with port mappings. However, you must manage potential conflicts with your host's existing services (like your own SSH server). 
⚠️ ***IMPORTANT**: Make sure to carefully read the **Security & System Integrity** section before attempting this approach to avoid accidental changes to your host's network configuration.*

### 2. Memory (RAM)

**Optimized for 4GB:** While a standard T-Pot requires 8-16 GB, this environment is tuned to run on as little as 4 GB of RAM.

**Stability:** 8 GB is recommended if you plan to keep the stack running for long periods or under heavy simulated attack, as Elasticsearch and Logstash are memory-intensive.

### 3. Networking & Port Conflicts

Honeypots "impersonate" real services to attract attackers.

**Default Setup:** Cowrie binds to ports 22 (SSH) and 23 (Telnet). If your host machine is already using these ports (especially port 22 for management), the containers will fail to start.

**Test Mode:** You can modify the docker-compose.yml to use non-standard ports (e.g., "2222:22"). This is perfectly fine for validating the IDMEFv2 conversion logic, although it makes the honeypot less "realistic" for actual external attackers.

### 🛡️ Security & System Integrity (Why a VM is required)

The `tpotinit` service is a core component of T-Pot that requires elevated privileges (`NET_ADMIN` and `host` network mode) to function correctly.

**Be aware that `tpotinit` will:**
- **Modify Network Settings:** It attempts to disable TCP offloading and reconfigure interface parameters to ensure honeypots receive raw, unaltered traffic.
- **Manage Firewall Rules:** It may alter `iptables` rules on the host to route traffic to the containers.
- **Adjust Permissions:** It performs a recursive `chown` on the data directory to ensure the T-Pot user (UID 2000) has correct access.

**For these reasons, running this stack on your primary OS is NOT recommended.** Using a dedicated VM protects your host's network configuration from being altered and ensures a clean, isolated environment for security testing.
*Note: Thanks to our optimizations, this VM only needs 4 GB of RAM, making it easy to run on most modern laptops.*

## Prerequisites

Before starting this application, the following repository must be cloned:
- https://github.com/IDMEFv2/idmefv2-connectors

In addition:
- A **dedicated VM** is strongly recommended for system integrity and realistic testing.
- Ensure the environment has enough resources (**4 GB RAM minimum**, **8 GB recommended** for long-running stability).
- Ensure required ports are free before starting the stack.

### Port availability check
Before running `docker compose up`, verify that the honeypot ports are not already in use by local services:
```bash
sudo netstat -tulpn | grep -E ':22|:23'
```

## Services

This application defines the following services:
- `tpotinit`: T-Pot initialization service (creates data directory structure, manages firewall rules)
- `cowrie`: Cowrie honeypot (https://github.com/cowrie/cowrie) — emulates SSH/Telnet services
- `elasticsearch`: Elasticsearch instance for storing T-Pot honeypot events
- `logstash`: Logstash pipeline that reads Cowrie logs and indexes them into Elasticsearch
- `tpot.idmefv2`: T-Pot IDMEFv2 connector — polls Elasticsearch for honeypot events and converts them to IDMEFv2 format

## Included services

This application includes the following services:
- `testserver.idmefv2`: a simple Python HTTP server validating IDMEFv2 messages received in POST requests (see [../testserver](../testserver))

## Architecture

```
                          ┌─────────────┐
  Attacker ──────────────►│   Cowrie     │
  (SSH/Telnet)            │  (honeypot)  │
                          └──────┬───────┘
                                 │ writes logs
                                 ▼
                          ┌─────────────┐
                          │  Logstash   │
                          │ (pipeline)  │
                          └──────┬───────┘
                                 │ indexes events
                                 ▼
                          ┌──────────────┐
                          │Elasticsearch │
                          └──────┬───────┘
                                 │ polls events
                                 ▼
                          ┌──────────────┐      POST IDMEFv2      ┌────────────┐
                          │ tpot.idmefv2 │ ─────────────────────► │ testserver  │
                          │ (connector)  │                        │ (IDMEFv2)  │
                          └──────────────┘                        └────────────┘
```

## Setup

1. Copy `.sample.env` to `.env`:
   ```bash
   cp .sample.env .env
   ```

2. Edit `.env` and set `IDMEFV2_CONNECTORS_GIT` to the absolute path of your cloned `idmefv2-connectors` repository.

3. Generate a valid `WEB_USER` (required by tpotinit):
   ```bash
   htpasswd -n -b "test" "test" | base64 -w0
   ```
   Replace the `WEB_USER` value in `.env` with the output.

4. Start the environment:
   ```bash
   docker compose up -d
   ```

5. Wait for all services to be healthy (tpotinit may take a minute):
   ```bash
   docker compose ps
   ```

## Environment variables

| Variable                 | Required | Default value                                       | Description                                                       |
| ------------------------ | -------- | --------------------------------------------------- | ----------------------------------------------------------------- |
| IDMEFV2_CONNECTORS_GIT  | Yes      | None                                                | Directory where `idmefv2-connectors` repository was cloned        |
| CONNECTOR_CONFIG_FILE    | No       | `./files/tpot-idmefv2.conf`                         | Connector configuration file                                      |
| TPOT_REPO               | No       | `ghcr.io/telekom-security`                          | Docker image registry for T-Pot images                            |
| TPOT_VERSION             | No       | `24.04.1`                                           | T-Pot version tag                                                 |
| TPOT_PULL_POLICY         | No       | `always`                                            | Docker image pull policy                                          |
| TPOT_DATA_PATH           | No       | `./data`                                            | T-Pot data directory                                              |
| WEB_USER                 | Yes      | None                                                | Base64 encoded htpasswd string (required by tpotinit)             |

## Volumes

| Service          | Volume type  | Source                          | Target                          |
| ---------------- | ------------ | ------------------------------- | ------------------------------- |
| tpotinit         | bind         | `${TPOT_DATA_PATH}`            | `/data`                         |
| cowrie           | bind         | `${TPOT_DATA_PATH}/cowrie/downloads` | `/home/cowrie/cowrie/dl`   |
| cowrie           | bind         | `${TPOT_DATA_PATH}/cowrie/keys`      | `/home/cowrie/cowrie/etc`  |
| cowrie           | bind         | `${TPOT_DATA_PATH}/cowrie/log`       | `/home/cowrie/cowrie/log`  |
| cowrie           | bind         | `${TPOT_DATA_PATH}/cowrie/log/tty`   | `/home/cowrie/cowrie/log/tty` |
| elasticsearch    | bind         | `${TPOT_DATA_PATH}`            | `/data`                         |
| logstash         | bind         | `${TPOT_DATA_PATH}`            | `/data`                         |
| tpot.idmefv2     | bind         | `${IDMEFV2_CONNECTORS_GIT}`    | `/idmefv2-connectors`           |

## Exposed interfaces

| Service       | Port          | Description                  |
| ------------- | ------------- | ---------------------------- |
| cowrie        | 22            | SSH honeypot                 |
| cowrie        | 23            | Telnet honeypot              |
| elasticsearch | 127.0.0.1:64298 | Elasticsearch HTTP API     |
| testserver    | 9999          | IDMEFv2 test server          |

## Testing

### Recommended test mode (closest to real usage)

The most realistic and most tested workflow is:

1. Start the full test stack on the dedicated VM (`tpotinit` + `cowrie` + `tpot.idmefv2`).
2. Keep the connector logs visible on the same VM.
3. From an **external machine** (for example, the host computer running the VM), perform an SSH connection attempt to the VM on port `22`.

Example:

On the VM (start stack):

```bash
docker compose up -d
docker logs -f tpot-idmefv2
```

From an external machine (towards VM IP):

```bash
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@<VM_IP> || true
```

This is the preferred validation path because it reproduces the real network flow: external attacker traffic enters Cowrie, gets processed by the T-Pot pipeline, and is converted by `tpot.idmefv2`.

### Alternative quick local check

To trigger a Cowrie event quickly from inside the same machine, connect to one of the honeypot ports:

```bash
# Trigger SSH connection attempt (will be detected by Cowrie)
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@127.0.0.1 || true

# Trigger Telnet connection attempt
telnet 127.0.0.1 23 || true
```

Then check the logs:

```bash
# Check Cowrie is receiving connections
docker logs cowrie

# Check Elasticsearch has indexed events
curl -s http://127.0.0.1:64298/logstash-*/_count | python3 -m json.tool

# Check the connector is polling and converting
docker logs tpot-idmefv2

# Check the test server received IDMEFv2 alerts
docker logs $(docker ps -qf "name=testserver")
```

## Additional information

- Application containers use logging to display their output, which can be viewed using `docker logs`.
- On the first run, `tpotinit` creates the data directory structure. It will attempt to contact Kibana (which is not included) and block on that step, but the health check already passes so all other containers start normally.
- The connector polls Elasticsearch every 10 seconds (configurable in the connector config file).
- Set `catch_up = true` in the connector config to process existing events at startup, or `catch_up = false` to only process new events.
