// Background script — toolbar button fallback
console.log("Markdown Viewer: background script loaded");

browser.action.onClicked.addListener(async (tab) => {
  if (!tab.url || !tab.url.startsWith("file://")) return;
  if (!/\.md$/i.test(tab.url) && !/\.markdown$/i.test(tab.url)) return;

  try {
    await browser.tabs.executeScript(tab.id, { file: "marked.min.js" });
    await browser.tabs.executeScript(tab.id, { file: "content.js" });
    console.log("Markdown Viewer: injected via toolbar button");
  } catch (e) {
    console.error("Markdown Viewer: toolbar injection failed:", e.message);
  }
});
