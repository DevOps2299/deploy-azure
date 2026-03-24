# Azure VM Setup Guide

One-time setup to get the full stack running on Azure. Do this before the demo.

---

## 1. Create the Azure VM

1. Azure Portal → **Create a resource** → **Virtual Machine**
2. Configure:
   - **Image:** Ubuntu Server 22.04 LTS
   - **Size:** B1s (free tier eligible)
   - **Authentication:** SSH public key
   - **Username:** `azureuser`
   - Generate a new key pair and **download the `.pem` file**
3. Click **Review + Create**

---

## 2. Open Required Ports

In the VM's **Networking** blade → **Add inbound port rule** — add each:

| Port | Purpose |
|---|---|
| 22 | SSH |
| 5000 | Flask app |
| * | ICMP to allow ping from My IP |

---

## 3. SSH into the VM

```bash
chmod 400 azureabc.pem
ssh -i azureabc.pem azureuser@<VM_PUBLIC_IP>
```

---


## 4. Run the Setup Script

The `setup.sh` script clones the repo, installs Python dependencies, and registers the Flask app as a systemd service:

```bash
curl -o setup.sh https://raw.githubusercontent.com/DevOps2299/deploy-azure/main/setup.sh
bash setup.sh
```

Or clone the repo manually first:

```bash
git clone https://github.com/DevOps2299/deploy-azure.git /home/azureuser/deploy-azure
bash /home/azureuser/deploy-azure/setup.sh
```

Verify the service is running:

```bash
sudo systemctl status flaskapp
```


---

## 5. Configure GitHub Secrets

In your GitHub repo → **Settings** → **Secrets and variables** → **Actions** → **New repository secret**:

| Secret Name | Value |
|---|---|
| `AZURE_VM_HOST` | VM public IP address |
| `AZURE_VM_USER` | `azureuser` |
| `AZURE_VM_SSH_KEY` | Contents of the `.pem` file |

To get the `.pem` contents:

```bash
cat azureabc.pem
```

Copy the entire output (including `-----BEGIN RSA PRIVATE KEY-----` lines) into the secret value.

---

## 6. Configure Uptime Kuma Monitor

1. Open `http://<VM_IP>:3001` and create an account
2. **Add New Monitor:**
   - Type: **HTTP(s)**
   - Name: `Flask App`
   - URL: `http://<VM_IP>:5000`
   - Heartbeat Interval: 60 seconds
3. Save — the monitor should turn green within a minute

---

## Verification Checklist

- [ ] `http://<VM_IP>:5000` — Flask app loads
- [ ] `http://<VM_IP>:3001` — Uptime Kuma shows green monitor
- [ ] Push a commit to `main` — GitHub Actions `test` then `deploy` jobs complete successfully
- [ ] Push a commit to `main` — GitHub Actions `test` then `deploy` jobs complete successfully
