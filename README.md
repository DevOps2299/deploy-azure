# deploy-azure

A Flask web app deployed to an Azure VM via GitHub Actions CI/CD pipeline. Built as part of a DevOps course (CSD-4503W) to demonstrate automated deployment pipelines.

## Stack

- **Python / Flask** — web application
- **Gunicorn** — WSGI server
- **systemd** — process management on the VM
- **GitHub Actions** — CI/CD pipeline
- **Uptime Kuma** — uptime monitoring (Docker)

## Local Development

```bash
pip install -r requirements.txt
python app.py
```

App runs at `http://localhost:5000`.

## Deployment

Pushing to `main` automatically deploys to the Azure VM via GitHub Actions (`.github/workflows/deploy.yml`). The workflow SSHs into the VM, pulls the latest code, and restarts the `flaskapp` systemd service.

### Required GitHub Secrets

| Secret | Description |
|---|---|
| `AZURE_VM_HOST` | Public IP or hostname of the Azure VM |
| `AZURE_VM_USER` | SSH username (e.g. `azureuser`) |
| `AZURE_VM_SSH_KEY` | Private SSH key for the VM |

## First-Time VM Setup

Run `setup.sh` on the Azure VM to clone the repo, install dependencies, and register the systemd service:

```bash
bash setup.sh
```

## Monitoring

Uptime Kuma runs on port `3001` via Docker Compose:

```bash
docker compose up -d
```
