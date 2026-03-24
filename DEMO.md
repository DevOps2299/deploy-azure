# Demo Walkthrough — Deployment Pipelines in Action

This guide walks through a live class demo of the full CI/CD pipeline: local development → automated testing → deployment to Azure.

---

## Prerequisites (set up before class)

- Azure VM is running and accessible
- GitHub Secrets are configured (`AZURE_VM_HOST`, `AZURE_VM_USER`, `AZURE_VM_SSH_KEY`)
- `setup.sh` has been run on the VM at least once to register the systemd service
- Docker is running on the VM (for Uptime Kuma)

---

## Step 1: Show the App Running Locally

```bash
pip install -r requirements.txt
python app.py
```

Open `http://localhost:5000` in the browser. Show students the live page.

**Talking point:** This is just a local Flask dev server — not production-ready. That's what Gunicorn and systemd are for on the VM.

---

## Step 2: Run Tests Locally

```bash
pytest
```

Show the passing output. Explain that this same command runs automatically in the pipeline before any deployment happens.

---

## Step 3: Make a Visible Change

Edit `templates/index.html` — change the heading so students can see it propagate to the live site. For example:

```html
<h2 class="mb-3">Hello from Azure! Updated live in class!</h2>
```

---

## Step 4: Commit and Push

```bash
git add templates/index.html
git commit -m "Live demo update"
git push origin main
```

---

## Step 5: Watch the Pipeline

Open the repository on GitHub → **Actions** tab.

Point out:
- The `test` job runs first
- The `deploy` job only starts after `test` passes (`needs: test`)
- This is the **gate** that prevents broken code from reaching the VM

---

## Step 6: Verify the Live Change

Once the `deploy` job completes, open `http://<AZURE_VM_IP>:5000` in the browser.

Show students the updated heading — the same change made locally is now live on the Azure VM.

---

## Step 7: Show Monitoring

Open `http://<AZURE_VM_IP>:3001` — this is Uptime Kuma.

Show that the monitor is green and tracking the app's uptime. Explain that this is running as a Docker container alongside the Flask app.

---

## Bonus: Break the Pipeline on Purpose

Edit `test_app.py` to make the test fail:

```python
def test_home_returns_200(client):
    response = client.get("/")
    assert response.status_code == 500  # intentionally wrong
```

Push the change:

```bash
git add test_app.py
git commit -m "Intentionally broken test"
git push origin main
```

In GitHub Actions, show the `test` job failing and the `deploy` job **not running**. The live site is unchanged.

Revert:

```bash
git revert HEAD
git push origin main
```

Show the pipeline going green and the deploy resuming normally.
