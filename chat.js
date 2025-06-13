async function sendMessage() {
  let userInput = document.getElementById("user-input").value;
  if (userInput.trim() === "") return;

  let chatBox = document.getElementById("chat-box");

  // إضافة رسالة المستخدم
  let userMessage = document.createElement("div");
  userMessage.classList.add("message", "user");
  userMessage.textContent = userInput;
  chatBox.appendChild(userMessage);

  // تنظيف مربع الإدخال
  document.getElementById("user-input").value = "";

  // إرسال الطلب إلى Gemini API
  try {
    let response = await fetch("https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=AIzaSyA9VtFP24K4xYZ4Yu9maif1392HTyFcfaY", {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify({
        contents: [
          { parts: [{ text: userInput }] }
        ]
      })
    });

    let data = await response.json();
    let botReply = data.candidates[0].content.parts[0].text;

    // إضافة رسالة الذكاء الاصطناعي
    let botMessage = document.createElement("div");
    botMessage.classList.add("message", "bot");
    botMessage.textContent = botReply;
    chatBox.appendChild(botMessage);

    // تمرير المحادثة للأسفل
    chatBox.scrollTop = chatBox.scrollHeight;

  } catch (error) {
    console.error("حدث خطأ في الاتصال بـ API:", error);
  }
}