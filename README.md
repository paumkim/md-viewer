# md-viewer

Render `.md` files as styled HTML in your browser. Double-click any `.md` file and it opens in Firefox looking like GitHub-flavored Markdown — clean, readable, no clutter.

## Quick Start

```bash
git clone https://github.com/paumkim/md-viewer.git
cd md-viewer
./install.sh
```

Then double-click any `.md` file — it opens in Firefox, rendered as HTML.

## Usage

```
md2html file.md              # Convert and open in Firefox
md2html --stdout file.md     # Print HTML to stdout (pipe, redirect)
md2html --help               # Show help
```

### Examples

```bash
# View a markdown file
md2html README.md

# Pipe into a file
md2html --stdout notes.md > notes.html

# Combine with other tools
md2html --stdout report.md | xclip -selection clipboard
```

## How It Works

1. You open a `.md` file (double-click in file manager, or `md2html file.md`)
2. The script converts markdown to HTML using Python's `markdown` library
3. A temporary HTML file is written to `/tmp/md_<name>.html`
4. Firefox opens the temp file with GitHub-style styling

No browser extensions, no internet, no configuration.

## Install

The `install.sh` script does everything:

```bash
./install.sh
```

It will:

- Install the Python `markdown` dependency (`pip3 install markdown`)
- Symlink `md2html` to `~/.local/bin/`
- Register the `.md` file handler in `~/.local/share/applications/`
- Update the MIME database so `.md` files open with `md2html` by default

Make sure `~/.local/bin` is in your `PATH`. If not, add this to your `~/.bashrc`:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

## Requirements

- Python 3
- Firefox
- Linux with a desktop environment (for the file handler integration)

The `--stdout` flag works on any OS.

## Project Structure

```
md-viewer/
├── md2html               # Script: .md → styled HTML → Firefox
├── install.sh            # One-command installer for any Linux
├── mdviewer.desktop      # File handler (copied by install.sh)
├── requirements.txt      # Python dep: markdown
├── README.md             # This file
├── LICENSE               # MIT
├── .gitignore            # Ignores .agents/, __pycache__/
└── extension-archive/    # Firefox extension source (for later signing)
```

## License

MIT — free to use, modify, share.
