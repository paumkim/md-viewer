# Firefox Extension — Markdown Viewer (Archived)

This was the original approach: a Firefox Manifest V3 extension that renders `.md` files as styled HTML.

## Why Archived

The extension worked but had two blockers for permanent use:
1. Temporary extensions (loaded via `about:debugging`) don't persist after Firefox restart
2. To make it permanent, it needs signing via AMO (addons.mozilla.org)

Replaced by `md2html` (Python script + `.desktop` handler) which works without any browser extension.

## To Pick This Back Up

If you decide to build a dedicated Firefox extension:

1. Submit to AMO as an **unlisted** add-on (auto-validated, signed without human review)
2. Once signed and installed permanently, the "Allow access to file URLs" toggle appears in `about:addons`
3. Enable it for the extension
4. The extension will then auto-render `.md` files from `file:///` URLs

### Build
```bash
cd extension-archive
zip -r ../md-viewer.xpi .
# Then submit the .xpi to addons.mozilla.org
```

### Files
- `manifest.json` — MV3, content_scripts + background.js fallback
- `content.js` — reads page text, renders via marked.js
- `background.js` — toolbar button for manual re-render
- `marked.min.js` — Markdown parser (bundled, no network needed)
- `icons/` — toolbar icon

### Permissions Required
- `tabs` — to know which tab has a `.md` file
- `file:///*/*` host permission — to inject into local files
- "Allow access to file URLs" in `about:addons` (only appears for signed extensions)
