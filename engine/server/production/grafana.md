## Setting up Prometheus

### Install and configure Prometheus

* Download the latest version of Prometheus from the [official website](https://prometheus.io/download/).

```bash
wget https://github.com/prometheus/prometheus/releases/download/v3.0.0-beta.0/prometheus-3.0.0-beta.0.linux-amd64.tar.gz
tar -xvf prometheus-3*.tar.gz
rm prometheus-3*.tar.gz
mv prometheus-3* prometheus
cd prometheus
```

* Create a configuration file `prometheus.yml` in the `prometheus` directory with following contents

```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'postgres_metrics'
    static_configs:
      - targets: ['localhost:9187']

  - job_name: 'node_exporter'
    static_configs:
      - targets: ['localhost:9100']
    scrape_interval: 1m

  - job_name: 'postgres_exporter'
    static_configs:
      - targets: ['localhost:9187']
    scrape_interval: 1m
```

* Create an admin user for Prometheus (using basic auth)
  * Use following Python script to generate a password hash

```python
import getpass
import bcrypt

password = getpass.getpass("password: ")
hashed_password = bcrypt.hashpw(password.encode("utf-8"), bcrypt.gensalt())
print(hashed_password.decode())
```

  * Add the following lines to the `web.yml` file

```
basic_auth_users:
  # example: username is 'idlez' and password is '1234'
  idlez: $2b$12$sN993rS7SE6AwQaApn2yk.Yjt0nU4dRThchRIsRDHwxJ5rGAHapja
```

* Run Prometheus
  * Create a run script `run.sh` with the following contents

```bash
#!/bin/bash
./prometheus --config.file=prometheus.yml --web.config.file=web.yml
```

### Register Prometheus as a service
* Create a service file `/etc/systemd/system/prometheus.service` with the following contents

```ini
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/var/lib/prometheus/

[Install]
WantedBy=multi-user.target
```

* Create the required directories, and copy the configuration files to the appropriate directories

```bash
sudo useradd --no-create-home --shell /bin/false prometheus
sudo mkdir /etc/prometheus
sudo cp prometheus.yml /etc/prometheus/prometheus.yml
sudo cp web.yml /etc/prometheus/web.yml
sudo mkdir /var/lib/prometheus
sudo cp prometheus /usr/local/bin/prometheus
sudo cp promtool /usr/local/bin/promtool
sudo chown -R prometheus:prometheus /etc/prometheus /var/lib/prometheus
sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl enable prometheus
```


### Install and configure Postgres Exporter

* Download the latest version of Postgres Exporter.

```bash
wget https://github.com/prometheus-community/postgres_exporter/releases/download/v0.15.0/postgres_exporter-0.15.0.linux-amd64.tar.gz
tar xvfz postgres_exporter-*.tar.gz
rm postgres_exporter-*.tar.gz
mv postgres_exporter-*.linux-amd64 postgres_exporter
cd postgres_exporter
```

* Create a run script `run.sh` with the following contents

```bash
#!/bin/bash
export DATA_SOURCE_NAME="postgresql://{DB_USERNAME}:{DB_PASSWORD}@{DB_HOSTNAME}/{DB_NAME}?sslmode=disable"
./postgres_exporter
```

#### Register Postgres Exporter as a service

* Create a service file `/etc/systemd/system/postgres_exporter.service` with the following contents

```ini
[Unit]
Description=Prometheus PostgreSQL Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=postgres_exporter
Group=postgres_exporter
Type=simpleZZZ
EnvironmentFile=/etc/prometheus/postgres_exporter.env
ExecStart=/usr/local/bin/postgres_exporter --extend.query-path=/etc/prometheus/queries.yml --disable-default-metrics
Restart=always

[Install]
WantedBy=multi-user.target
```

* Create an environment file `/etc/prometheus/postgres_exporter.env` with the following contents

```bash
DATA_SOURCE_NAME="postgresql://{DB_USERNAME}:{DB_PASSWORD}@{DB_HOSTNAME}/{DB_NAME}?sslmode=disable"
```

* Create a configuration file `/etc/prometheus/queries.yml` with the custom queries

```yaml
pg_custom:
  query: "SELECT AVG(count) AS avg_count FROM public.player_items WHERE item_data_id = 2 AND updated_at >= NOW() - INTERVAL '1 week'"
  metrics:
    - avg_count:
        usage: "GAUGE"
        description: "Average count for item_data_id=2 in the last week"
```

* Create the required directories, and copy the configuration files to the appropriate directories

```bash
sudo useradd --no-create-home --shell /bin/false postgres_exporter
sudo cp postgres_exporter /usr/local/bin/postgres_exporter
sudo chown -R postgres_exporter:postgres_exporter /usr/local/bin/postgres_exporter
sudo systemctl daemon-reload
sudo systemctl start postgres_exporter
sudo systemctl enable postgres_exporter
```


### Install and configure Node Exporter

* Download the latest version of Node Exporter from the [official repository](https://github.com/prometheus/node_exporter/).

```bash
wget https://github.com/prometheus/node_exporter/releases/download/v1.8.2/node_exporter-1.8.2.linux-amd64.tar.gz
tar xvfz node_exporter-*.tar.gz
rm node_exporter-*.tar.gz
mv node_exporter-*.linux-amd64 node_exporter
cd node_exporter
```

* Create a run script `run.sh` with the following contents

```bash
#!/bin/bash
./node_exporter
```

#### Register Node Exporter as a service

* Create a service file `/etc/systemd/system/node_exporter.service` with the following contents

```ini
[Unit]
Description=Prometheus Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
```

* Create the required directories, and copy the configuration files to the appropriate directories

```bash
sudo useradd --no-create-home --shell /bin/false node_exporter
sudo cp node_exporter /usr/local/bin/node_exporter
sudo chown -R node_exporter:node_exporter /usr/local/bin/node_exporter
sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl enable node_exporter
```

### (Optional) Configure reverse proxy for Prometheus using Nginx

* Setup Nginx with the following configuration (replace `example.com` with your domain name)

```nginx
server {
    listen 80;
    listen [::]:80;
    server_name example.com;
    location / {
        proxy_pass http://localhost:9090;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

## Setting up Grafana

### Install and configure Grafana

* Download the latest version of Grafana from the [official website](https://grafana.com/grafana/download).

```bash
sudo apt-get install -y adduser libfontconfig1 musl
wget https://dl.grafana.com/enterprise/release/grafana-enterprise_11.2.0_amd64.deb
sudo dpkg -i grafana-enterprise_11.2.0_amd64.deb
sudo systemctl start grafana-server
sudo systemctl enable grafana-server
```

* Edit the configuration file `/etc/grafana/grafana.ini` and set the following values

```ini
[server]
protocol = http
http_port = 3000
root_url = https://example.com/
```

### (Optional) Configure reverse proxy using Nginx

* Setup Nginx with the following configuration (replace `example.com` with your domain name)

```nginx
server {
    listen 80;
    listen [::]:80;
    server_name example.com;
    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```
