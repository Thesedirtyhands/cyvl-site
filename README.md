# cyvl-site

## Dev preview

### Windows PowerShell (recommended)

From the repository root, run:

```powershell
.\scripts\dev-preview.ps1
```

If script execution is blocked, run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\dev-preview.ps1
```

You can also use the CMD wrapper:

```powershell
.\scripts\dev-preview.cmd
```

### macOS/Linux/WSL (bash)

```bash
./scripts/dev-preview.sh
```

What it does:
- serves the `website/` folder directly (so `/` is your site)
- starts a local static server at port `8000`
- binds to `0.0.0.0` (reachable from host/VM setups)
- prints `localhost`, `127.0.0.1`, and LAN URLs
- attempts to auto-open your browser

## Options

### PowerShell

```powershell
.\scripts\dev-preview.ps1 -Port 8080 -HostName 127.0.0.1 -SiteDir website
```

### Bash

```bash
HOST=127.0.0.1 SITE_DIR=website ./scripts/dev-preview.sh 8080
```

If you are using Docker/WSL/remote VM/container, open the printed URL from your host machine browser (not from inside the shell session).
