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

### SFTP access
- Connect: `sftp -P 2222 <SFTP_USER>@localhost`
- Root directory exposes `wp-content` mapped from the WordPress container volume. UID/GID `33:33` matches `www-data` in the WordPress image for correct permissions.

### Environment variables
See `.env.example`:
- `DB_NAME`, `DB_USER`, `DB_PASSWORD`, `DB_ROOT_PASSWORD`
- `SFTP_USER`, `SFTP_PASSWORD`

### Data persistence
- Database data stored in Docker volume `db_data`.
- WordPress content stored in `wp_data` and shared with SFTP.

### Customization
- Change published ports by editing `docker-compose.yml` (defaults: `8080` for HTTP, `2222` for SFTP).
- Add additional SFTP users by switching to a bind-mounted users file; see `atmoz/sftp` docs.

### Maintenance
- Stop: `docker compose down`
- Stop and remove volumes (DANGEROUS): `docker compose down -v`


