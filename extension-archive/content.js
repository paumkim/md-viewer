// Content script — renders .md file as styled HTML
console.log("Markdown Viewer: content script loaded on", window.location.href);

(function() {
  const href = window.location.href;
  const isMd = /\.md$/i.test(href) || /\.markdown$/i.test(href);
  if (!isMd) {
    console.log("Markdown Viewer: not a .md file, skipping");
    return;
  }

  // Grab raw markdown text
  const text = document.body?.textContent || document.documentElement?.innerText || "";
  if (!text.trim()) {
    console.log("Markdown Viewer: no text content found");
    return;
  }

  if (typeof marked === "undefined") {
    document.body.innerHTML = "<p style='color:red;font-size:24px;'>Markdown Viewer: marked library not loaded</p>";
    return;
  }

  try {
    marked.setOptions({ breaks: true, gfm: true });
    const html = marked.parse(text);

    const style = `
      * { margin: 0; padding: 0; box-sizing: border-box; }
      body {
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, Arial, sans-serif;
        max-width: 820px; margin: 40px auto; padding: 0 20px;
        line-height: 1.6; color: #1f2328; background: #fff;
      }
      pre { background: #f6f8fa; padding: 16px; border-radius: 6px; overflow-x: auto; margin: 16px 0; }
      code { background: #f6f8fa; padding: 2px 6px; border-radius: 4px; font-size: 0.9em; }
      pre code { background: none; padding: 0; }
      table { border-collapse: collapse; width: 100%; margin: 16px 0; }
      th, td { border: 1px solid #d0d7de; padding: 8px 12px; text-align: left; }
      th { background: #f6f8fa; font-weight: 600; }
      img { max-width: 100%; }
      blockquote { border-left: 4px solid #d0d7de; padding-left: 16px; margin: 16px 0; color: #656d76; }
      h1, h2, h3 { border-bottom: 1px solid #d0d7de; padding-bottom: 8px; margin: 24px 0 16px; }
      h1 { font-size: 2em; } h2 { font-size: 1.5em; } h3 { font-size: 1.25em; }
      p { margin: 16px 0; }
      a { color: #0969da; }
      ul, ol { padding-left: 24px; margin: 16px 0; }
      li { margin: 4px 0; }
      hr { border: none; border-top: 1px solid #d0d7de; margin: 24px 0; }
    `;

    document.open();
    document.write(`<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="color-scheme" content="light">
  <title>${document.title || "Markdown"}</title>
  <style>${style}</style>
</head>
<body>${html}</body>
</html>`);
    document.close();

    console.log("Markdown Viewer: rendered successfully");
  } catch (e) {
    console.error("Markdown Viewer error:", e);
    document.body.innerHTML = "<p style='color:red;font-size:18px;'>Markdown Viewer error: " + e.message + "</p>";
  }
})();
