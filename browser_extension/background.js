chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  if (message.type === "CAN_SCAN") {
    const allowed = sender?.tab?.active === true;
    sendResponse({ allowed });
    return;
  }

  if (message.type === "MODERATE_TEXT") {
    if (!sender?.tab?.active) {
      sendResponse({ status: "neutral" });
      return;
    }

    fetch("http://localhost:8000/process_content/process_text", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        text: message.text,
        modes: { sexualcontent: true },
        user_id: 'kenkaroki92@gmail.com'
      }),
    })
      .then((res) => res.json())
      .then((data) => sendResponse(data))
      .catch(() => sendResponse({ status: "neutral" }));

    return true;
  }
});
