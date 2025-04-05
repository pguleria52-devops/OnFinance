# Monitoring Setup Documentation

This folder contains resources and instructions for setting up monitoring for your infrastructure and applications using **Prometheus**, **Grafana**, **AWS SNS**, and **Node Exporter**. It also includes configurations for logging using **Fluent Bit**.

---

## Folder Structure

- alert.tf - Terraform configuration for CloudWatch alarms 

- daemon.yml - Kubernetes DaemonSet for Fluent Bit logging 
- README.md - Step-by-step guide for setting up monitoring tools



## 1. AWS SNS Alerts

### Create an SNS Topic
Use the following command to create an SNS topic for alerts:
```
aws sns create-topic --name eks-alerts
```
Subscribe to the SNS Topic
Subscribe to the topic to receive email notifications:
```
aws sns subscribe --topic-arn arn:aws:sns:us-east-1:123456789012:eks-alerts --protocol email --notification-endpoint your-email@example.com
```
Replace your-email@example.com with your email address. Confirm the subscription by clicking the link in the email you receive.

## 2. Prometheus Setup
Prometheus is used to collect and store metrics from your applications and infrastructure.

Steps to Install Prometheus

1. Create a Dedicated User:
```
sudo useradd --system --no-create-home --shell /bin/false prometheus
```

2. Download Prometheus
```
wget https://github.com/prometheus/prometheus/releases/download/v2.47.1/prometheus-2.47.1.linux-amd64.tar.gz
```

3. Extract and Move Files
```
tar -xvf prometheus-2.47.1.linux-amd64.tar.gz
cd prometheus-2.47.1.linux-amd64/
sudo mkdir -p /data /etc/prometheus
sudo mv prometheus promtool /usr/local/bin/
sudo mv consoles/ console_libraries/ /etc/prometheus/
sudo mv prometheus.yml /etc/prometheus/prometheus.yml
```

4. Set Ownership
```
sudo chown -R prometheus:prometheus /etc/prometheus/ /data/
```

5. Create a Systemd Service: Create a file at ```/etc/systemd/system/prometheus.service ``` with the following content:

```
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
  --storage.tsdb.path=/data \
  --web.console.templates=/etc/prometheus/consoles \
  --web.console.libraries=/etc/prometheus/console_libraries \
  --web.listen-address=0.0.0.0:9090 \
  --web.enable-lifecycle
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

6. Enable and Start Prometheus:
```
sudo systemctl enable prometheus
sudo systemctl start prometheus
```

7. Access Prometheus: Open your browser and navigate to:
```
http://<your-server-ip>:9090
```

## 3. Node Exporter Setup
Node Exporter collects system-level metrics (CPU, memory, disk, etc.).

Steps to Install Node Exporter
1. Create a Dedicated User:
 ``` 
 sudo useradd --system --no-create-home --shell /bin/false node_exporter 
 ```

2. Download Node Exporter:
```
wget https://github.com/prometheus/node_exporter/releases/download/v1.6.1/node_exporter-1.6.1.linux-amd64.tar.gz
``` 

3. Extract and Move Files:
```
tar -xvf node_exporter-1.6.1.linux-amd64.tar.gz
sudo mv node_exporter-1.6.1.linux-amd64/node_exporter /usr/local/bin/
rm -rf node_exporter*
```

4. Create a Systemd Service: Create a file at ```/etc/systemd/system/node_exporter.service``` with the following content:
```
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

5. Enable and Start Node Exporter
```
sudo systemctl enable node_exporter
sudo systemctl start node_exporter
```

6. Access Node Exporter Metrics: Open your browser and navigate to:
```
http://<your-server-ip>:9100/metrics
```

## 4. Grafana Setup
Grafana is used to visualize metrics collected by Prometheus.

Steps to Install Grafana
1. Install Dependencies:
```
sudo apt-get update
sudo apt-get install -y apt-transport-https software-properties-common
```

2. Add Grafana GPG Key:
```
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
```

3. Add Grafana Repository
```
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
```

4. Install Grafana
```
sudo apt-get update
sudo apt-get -y install grafana
```

5. Enable and Start Grafana
```
sudo systemctl enable grafana-server
sudo systemctl start grafana-server
```

6. Access Grafana: Open your browser and navigate to:
```
http://<your-server-ip>:3000
```
Default credentials:
- Username: ```admin```
- Password: ```admin```

7. Add Prometheus as a Data Source:
- Go to Configuration > Data Sources.
- Click Add data source and select Prometheus.
- Set the URL to ```http://localhost:9090``` and click Save & Test.

8. Import Dashboards:
- Go to Create > Import.
- Enter a dashboard ID (e.g., ```1860```) and click Load.
- Select Prometheus as the data source and click Import.

## 5. Fluent Bit Logging (DaemonSet)
The ```daemon.yml``` file contains a Kubernetes DaemonSet configuration for Fluent Bit, which collects logs from all nodes in the cluster.

Deploy Fluent Bit
1. Apply the DaemonSet:
```
kubectl apply -f daemon.yml
```

2. Verify the DaemonSet:
```
kubectl get daemonset -n logging
```

## 6. CloudWatch Alarms (Terraform)
The ```alert.tf``` file contains a Terraform configuration for creating a CloudWatch alarm to monitor high CPU usage in EKS.

Deploy the Alarm
1. Initialize Terraform:
```
terraform init
```
2. Apply the Configuration:
```
terraform apply
```

3. Verify the Alarm in the AWS Management Console under CloudWatch > Alarms.

### Notes
- Replace ```<your-server-ip>``` with the IP address of your server.
- Ensure necessary ports (e.g., 9090 for Prometheus, 9100 for Node Exporter, 3000 for Grafana) are open in your firewall or security group.
- Customize configurations as needed for your environment.