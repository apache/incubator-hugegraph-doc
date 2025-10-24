# AI Development Agent Instructions

This file provides guidance to AI coding assistants (Claude Code, Cursor, GitHub Copilot, etc.) when working with code in this repository.

## Project Overview

This is the **Apache HugeGraph documentation website** repository (`hugegraph-doc`), built with Hugo static site generator using the Docsy theme. The site provides comprehensive documentation for the HugeGraph graph database system, including quickstart guides, API references, configuration guides, and contribution guidelines.

The documentation is multilingual, supporting both **Chinese (cn)** and **English (en)** content.

## Development Setup

### Prerequisites

1. **Hugo Extended** (v0.95.0 recommended, v0.102.3 used in CI)
   - Must be the "extended" version (includes SASS/SCSS support)
   - Download from: https://github.com/gohugoio/hugo/releases
   - Install location: `/usr/bin` or `/usr/local/bin`

2. **Node.js and npm** (v16+ as specified in CI)

### Quick Start

```bash
# Install npm dependencies (autoprefixer, postcss, postcss-cli)
npm install

# Start local development server (with auto-reload)
hugo server

# Custom server with different ip/port
hugo server -b http://127.0.0.1 -p 80 --bind=0.0.0.0

# Build production site (output to ./public)
hugo --minify
```

## Project Structure

### Key Directories

- **`content/`** - All documentation content in Markdown
  - `content/cn/` - Chinese (simplified) documentation
  - `content/en/` - English documentation
  - Each language has parallel structure: `docs/`, `blog/`, `community/`, `about/`

- **`themes/docsy/`** - The Docsy Hugo theme (submodule or vendored)

- **`static/`** - Static assets (images, files) served directly

- **`assets/`** - Assets processed by Hugo pipelines (SCSS, images for processing)

- **`layouts/`** - Custom Hugo template overrides for the Docsy theme

- **`public/`** - Generated site output (gitignored, created by `hugo` build)

- **`dist/`** - Additional distribution files

### Important Files

- **`config.toml`** - Main site configuration
  - Defines language settings (cn as default, en available)
  - Menu structure and navigation
  - Theme parameters and UI settings
  - Currently shows version `0.13`

- **`package.json`** - Node.js dependencies for CSS processing (postcss, autoprefixer)

- **`.editorconfig`** - Code style rules (UTF-8, LF line endings, spaces for indentation)

- **`contribution.md`** - Contributing guide (Chinese/English mixed)

- **`maturity.md`** - Project maturity assessment documentation

## Content Organization

Documentation is organized into major sections:

- **`quickstart/`** - Getting started guides for HugeGraph components (Server, Loader, Hubble, Tools, Computer, AI)
- **`config/`** - Configuration documentation
- **`clients/`** - Client API documentation (Gremlin Console, RESTful API)
- **`guides/`** - User guides and tutorials
- **`performance/`** - Performance benchmarks and optimization
- **`language/`** - Query language documentation
- **`contribution-guidelines/`** - How to contribute to HugeGraph
- **`changelog/`** - Release notes and version history
- **`download/`** - Download links and instructions

## Common Tasks

### Building and Testing

```bash
# Build for production (with minification)
hugo --minify

# Clean previous build
rm -rf public/

# Build with specific environment
HUGO_ENV="production" hugo --gc
```

### Working with Content

When editing documentation:

1. Maintain parallel structure between `content/cn/` and `content/en/`
2. Use Markdown format for all documentation files
3. Include front matter in each file (title, weight, description)
4. For translated content, ensure both Chinese and English versions are updated

### Theme Customization

- Global site config: `config.toml` (root directory)
- Theme-specific config: `themes/docsy/config.toml`
- Custom layouts: Place in `layouts/` to override theme defaults
- Custom styles: Modify files in `assets/` directory

Refer to [Docsy documentation](https://www.docsy.dev/docs/) for theme customization details.

## Deployment

The site uses GitHub Actions for CI/CD (`.github/workflows/hugo.yml`):

1. **Triggers**: On push to `master` branch or pull requests
2. **Build process**:
   - Checkout with submodules (for themes)
   - Setup Node v16 and Hugo v0.102.3 extended
   - Run `npm i && hugo --minify`
3. **Deployment**: Publishes to `asf-site` branch (GitHub Pages)

The deployed site is hosted as part of Apache HugeGraph's documentation infrastructure.

## HugeGraph Architecture Context

This documentation covers the complete HugeGraph ecosystem:

- **HugeGraph-Server** - Core graph database engine with REST API
- **HugeGraph-Store** - Distributed storage engine with integrated computation
- **HugeGraph-PD** - Placement Driver for metadata management
- **HugeGraph-Toolchain**:
  - Client (Java RESTful API client)
  - Loader (data import tool)
  - Hubble (web visualization platform)
  - Tools (deployment and management utilities)
- **HugeGraph-Computer** - Distributed graph processing system (OLAP)
- **HugeGraph-AI** - Graph neural networks and LLM/RAG components

## Git Workflow

- **Main branch**: `master` (protected, triggers deployment)
- **PR requirements**: Include screenshots showing before/after changes in documentation
- **Commit messages**: Follow Apache commit conventions
- Always create a new branch from `master` for changes
- Deployment to `asf-site` branch is automated via GitHub Actions

## Troubleshooting

**Error: "TOCSS: failed to transform scss/main.scss"**
- Cause: Using standard Hugo instead of Hugo Extended
- Solution: Install Hugo Extended version

**Error: Module/theme not found**
- Cause: Git submodules not initialized
- Solution: `git submodule update --init --recursive`

**Build fails in CI but works locally**
- Check Hugo version match (CI uses v0.102.3)
- Ensure npm dependencies are installed
- Verify Node.js version (CI uses v16)
