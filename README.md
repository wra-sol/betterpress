## BetterPress: WordPress + SFTP in Docker

This stack runs WordPress (Apache, PHP 8.2) with MariaDB and exposes SFTP access into `wp-content` for theme/plugin/media management.

### Services
- **WordPress**: `http://localhost:8080`
- **MariaDB**: internal only
- **SFTP**: `sftp -P 2222 deploy@localhost` (password from `.env`)

### Quick start
1. Copy `.env.example` to `.env` and update secrets.
2. Start the stack:
   ```bash
   docker compose up -d
   ```
3. Open `http://localhost:8080` to complete WordPress setup.

> Note: `wp-content` is bind-mounted to `./data/wp-content` by default. Adjust with `WP_CONTENT_DIR` in `.env`.

### SFTP access
- Connect: `sftp -P 2222 <SFTP_USER>@localhost`
- Root directory exposes `wp-content` mapped from the WordPress container volume. UID/GID `33:33` matches `www-data` in the WordPress image for correct permissions.

### Environment variables
See `.env.example`:
- `DB_NAME`, `DB_USER`, `DB_PASSWORD`, `DB_ROOT_PASSWORD`
- `SFTP_USER`, `SFTP_PASSWORD`

### Data persistence
- Database data stored in Docker volume `db_data`.
- WordPress content bind-mounted to `./data/wp-content` (configurable via `WP_CONTENT_DIR`) and shared with SFTP.

### Customization
- Change published ports by editing `docker-compose.yml` (defaults: `8080` for HTTP, `2222` for SFTP).
- Add additional SFTP users by switching to a bind-mounted users file; see `atmoz/sftp` docs.

### Maintenance
- Stop: `docker compose down`
- Stop and remove volumes (DANGEROUS): `docker compose down -v`

### Deploying on Railway
- This repo includes a `Dockerfile` tuned for Railway. Apache binds to `$PORT` automatically.
- Create a Railway service from the repo.
- Add an app Volume and mount it to `/var/www/html/wp-content`.
- Set env vars: `DB_*` (if using an external DB) and any WordPress salts/keys as desired.
- Expose the default service port; Railway assigns an external URL.
- Note: Railway services expose a single public port; running SFTP alongside HTTP on the same service is not supported. If SFTP is required on Railway, create a separate service with an SFTP image and mount the same Volume, or use Railway's file mounts/CLI to manage uploads.

#### Config-as-code
- A `railway.json.example` is provided to define services from a single repo. Rename to `railway.json` and adjust as needed.
- The `web` service builds from the provided `Dockerfile` and expects a Volume mounted at `/var/www/html/wp-content`.
- The `sftp-optional` service is provided as a reference. If you enable it, mount the same Volume to `/home/$SFTP_USER/wp-content` and set `SFTP_USER`/`SFTP_PASSWORD`.


