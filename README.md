# Kurt's Personal Website (kurt)

Source code for the personal website hosted at [kurt.melby.me](https://kurt.melby.me).

This project is a complete port and modernization of the original website, built using real Elixir, Phoenix 1.8, and Tailwind CSS v4, while maintaining the exact original design and feel.

## Tech Stack Overview

- **Core**: Elixir & Phoenix 1.8 Framework (specifically utilizing `Phoenix.LiveView` for instant page navigation)
- **Design/UI**: Tailwind CSS v4 alongside native CSS variables for spacing and layout.
- **Database**: None. This is a purely static-content driven web application. It intentionally does not include `Ecto` or a PostgreSQL database to minimize moving parts and overhead.
- **Routing**: Client-side single-page application (SPA) feel powered completely by server-side rendered LiveViews.

## Implementation Details & Features

* **Single LiveView Routing**: The site is backed by a primary Phoenix LiveView (`KurtWeb.HomeLive.Index`). Instead of defining separate routes and controllers for each individual page (`/whoami`, `/résumé`, etc.), the router directs the root path and a generic `/:slug` path to this single central LiveView.
* **Dynamic Content Rendering**: When a path is accessed, the LiveView grabs the `slug` parameter from the URL. Based on the slug, it dynamically selectively renders the appropriate partial template (e.g., `_whoami.html.heex`, `_resume.html.heex`, `_projects.html.heex`).
* **Instant Page Transitions (SPA Feel)**: Navigation links use LiveView's `patch` functionality. When you click a menu item, the URL changes and the content swaps instantly without a full page reload, resulting in a snappy, SPA-like experience driven entirely from the server.
* **Stateless Content**: Because the application intentionally omits a database configuration, all text content (job history, project lists) is hardcoded directly into the `.heex` template files.
* **UI Flourishes**: The site incorporates CSS animations (`animate.min.css`), `Lato` Google Fonts, and SVG Heroicons via a seamless Tailwind plugin.

## Easter Eggs & Interactions

The site includes a few hidden interactive features and "easter eggs" built using Phoenix LiveView's Javascript hooks and CSS animations:

1. **Color Randomizer**: On each page load the right pane runs a brief "slot machine" roll through a few random pastels before landing on its chosen color for that visit. Afterwards, clicking an empty area of the colored pane (not on text, links, or images) re-rolls to a new color with a smooth transition. Works on every page. The roll is skipped when the browser reports `prefers-reduced-motion`.
2. **Physics Gravity Drop**: If you rapidly click the main "Kurtis Melby" header on the left side 5 times, physics kicks in. The letters detach and fall to the bottom of the screen with a bounce, then return to their place after about 20 seconds.
3. **Mirror Flip**: Clicking the mirrored "Kurtis Melby" ghost title on the right side briefly flips the entire desktop layout horizontally (via `scaleX(-1)`). The sidebar swaps sides, the menu text and real title mirror, and the ghost title becomes the only readable thing on the page. Auto-reverts after a few seconds.
4. **Page-aware browser title**: The document title updates based on the active route (e.g. `Projects · Kurt Melby`). The `etcetera` page keeps its keyboard-mash title for fun.

## Local Development

To run this application locally for development:

1. **Prerequisites**: Ensure you have [Elixir](https://elixir-lang.org/install.html) installed (requires version 1.15+).
2. **Install Setup**: Run `$ mix setup` to install and set up all Elixir (`hex`) dependencies and Node.js (`npm`) assets/compilers.
3. **Start the Server**: Run `$ mix phx.server` (or run it interactively with `$ iex -S mix phx.server`).

You can now visit [`localhost:4000`](http://localhost:4000) from your browser. The page will auto-reload when you modify templates, controllers, or CSS.

## Deployment to Fly.io

This project is fully configured for zero-downtime deployment on [Fly.io](https://fly.io).

### Steps to Deploy

1. Ensure the `flyctl` CLI tool is installed and you are authenticated (`fly auth login`).
2. Run the deployment command from the project root:
   ```bash
   fly deploy
   ```

### Deployment Architecture

- **Custom Dockerfile**: The build runs through a multi-stage `Dockerfile` (initially scaffolded via `mix phx.gen.release --docker`).
    - *Stage 1 (Builder)*: Uses a complete Elixir/Erlang Debian-slim image to compile the application logic, gather dependencies, and precompile/minify static assets (like JS hooks and Tailwind CSS).
    - *Stage 2 (Runner)*: Copies only the compiled release `/app/bin/server` payload into a fresh, minimal Debian-slim system image to keep the final container size small.
- **Configuration**:
    - The server dynamically reads environment variables set by Fly in production (see `config/runtime.exs`)
    - Specifically, the application forces HTTPS encryption (`force_ssl`), listens on `PORT 8080`, and checks incoming WebSockets strictly against the `PHX_HOST` environment variable (`kurt.melby.me`). 

