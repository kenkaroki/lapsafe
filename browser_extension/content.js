console.log("🔥 Safe Social Feed content.js RUNNING");

function normalizeHost(host) {
  return host
    .replace(/^https?:\/\//, "")
    .replace(/^www\./, "")
    .replace(/^m\./, "")
    .replace(/\/.*$/, "")
    .toLowerCase()
    .trim();
}

function isAllowedSite(allowedSites) {
  const host = normalizeHost(window.location.hostname);
  return allowedSites.some((site) => {
    const normalized = normalizeHost(site);
    return host === normalized || host.endsWith("." + normalized);
  });
}

function splitIntoSentences(text) {
  return text
    .split(/(?<=[.!?])\s+/)
    .map((s) => s.trim())
    .filter((s) => s.length > 3);
}

function scanPage() {
  // Only scan active tab
  chrome.runtime.sendMessage({ type: "CAN_SCAN" }, (res) => {
    if (!res?.allowed) {
      console.log("⏸️ Tab not active — skipping scan");
      return;
    }

    chrome.storage.sync.get(
      { enabled: true, mode: "blur", allowedSites: [] },
      (settings) => {
        if (!settings.enabled) return;

        if (
          settings.allowedSites.length > 0 &&
          !isAllowedSite(settings.allowedSites)
        ) {
          console.log("⛔ Site not allowed — skipping scan");
          return;
        }

        document.querySelectorAll("p, span, div").forEach((el) => {
          if (el.dataset.safeChecked) return;

          const text = el.innerText?.trim();
          if (!text || text.length < 10) return;

          el.dataset.safeChecked = "true";

          splitIntoSentences(text).forEach((sentence) => {
            chrome.runtime.sendMessage(
              { type: "MODERATE_TEXT", text: sentence },
              (response) => {
                if (chrome.runtime.lastError) {
                  console.warn(
                    "Message failed:",
                    chrome.runtime.lastError.message
                  );
                  return;
                }

                console.log(response?.status?.toLowerCase());

                if (response?.status?.toLowerCase() === "hateful") {
                  console.log(response?.status?.toLowerCase());
                  el.classList.add("safe-blur");
                }
              }
            );
          });
        });
      }
    );
  });
}

// Initial scan
scanPage();

// Watch dynamically loaded content
const observer = new MutationObserver(scanPage);
observer.observe(document.body, { childList: true, subtree: true });
