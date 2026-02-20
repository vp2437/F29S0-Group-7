import { useState, useRef, useEffect } from "react";
import { Send, Bot } from "lucide-react";
import "./assistant.css";
import Fuse from "fuse.js";

export const Assistant = () => {
  // Chat state
  const [messages, setMessages] = useState([
    { text: "Hey 👋 How can I help you today?", user: false },
  ]);
  const [input, setInput] = useState("");
  const [isTyping, setIsTyping] = useState(false);
  const messagesContainerRef = useRef(null);

  // Auto Scroll
  useEffect(() => {
    const container = messagesContainerRef.current;
    if (container) {
      container.scrollTop = container.scrollHeight;
    }
  }, [messages, isTyping]);

  // Send message
  const handleSend = () => {
    if (!input.trim()) return;

    const userMessage = input.trim();
    setMessages((prev) => [...prev, { text: userMessage, user: true }]);
    setInput("");
    setIsTyping(true);

    setTimeout(() => {
      const reply = getBotReply(userMessage.toLowerCase().trim());
      setMessages((prev) => [...prev, { text: reply, user: false }]);
      setIsTyping(false);
    }, 800);
  };

  // Bot replies
  const knowledgeBase = [
    {
      text: "dashboard home main page overview",
      response:
        "You can access your health overview from the Dashboard tab in the top navigation bar.",
    },
    {
      text: "goal goals target progress steps calories",
      response:
        "Visit the Goals section to set and track your daily steps and calorie targets.",
    },
    {
      text: "appointment appointments booking schedule book doctor visit",
      response:
        "You can book or manage appointments under the Appointments tab.",
    },
    {
      text: "prescription medicine medication drugs pharmacy",
      response:
        "Your prescriptions are available in the Prescriptions section of the app.",
    },
    {
      text: "contact doctor provider support help call",
      response:
        "You can contact your healthcare provider by booking an appointment through the Appointments section.",
    },
    {
      text: "exercise workout gym fitness training",
      response:
        "Regular exercise helps improve heart health, strengthen muscles, and maintain a healthy body and mind. Aim for at least 30 minutes daily.",
    },
    {
      text: "diet nutrition food eat healthy meals",
      response:
        "A balanced diet includes fruits, vegetables, lean proteins, whole grains, and plenty of water.",
    },
    {
      text: "water hydration drink thirsty fluids",
      response:
        "It’s generally recommended to drink around 2–3 liters of water per day, depending on your activity level.",
    },
    {
      text: "sleep rest tired insomnia bedtime",
      response:
        "Adults typically need 7–9 hours of quality sleep per night for optimal health.",
    },
    {
      text: "password change update account personal details settings profile",
      response:
        "You can update your password and personal details or view profile from the Settings tab.",
    },
    {
      text: "biomarker biomarkers vitals health metrics blood pressure heart rate detailed view",
      response:
        "You can view detailed biomarker data and health metrics in the Vitals tab, where you can track trends like blood oxygen level, heart rate, and other health indicators.",
    },
  ];

  const fuse = new Fuse(knowledgeBase, {
    keys: ["text"],
    threshold: 0.4,
    ignoreLocation: true,
    includeScore: true,
    minMatchCharLength: 4,
  });

  // Bot logic
  const getBotReply = (message) => {
    const cleaned = message.toLowerCase();

    if (cleaned.includes("water") || cleaned.includes("drink")) {
      return knowledgeBase[7].response;
    }

    if (
      cleaned.includes("appointment") ||
      cleaned.includes("book") ||
      cleaned.includes("schedule")
    ) {
      return knowledgeBase[2].response;
    }

    if (
      cleaned.includes("goal") ||
      cleaned.includes("target") ||
      cleaned.includes("progress")
    ) {
      return knowledgeBase[1].response;
    }

    if (
      cleaned.includes("dashboard") ||
      cleaned.includes("home") ||
      cleaned.includes("overview")
    ) {
      return knowledgeBase[0].response;
    }

    if (
      cleaned.includes("sleep") ||
      cleaned.includes("rest") ||
      cleaned.includes("tired")
    ) {
      return knowledgeBase[8].response;
    }

    if (
      cleaned.includes("diet") ||
      cleaned.includes("food") ||
      cleaned.includes("nutrition")
    ) {
      return knowledgeBase[6].response;
    }

    if (
      cleaned.includes("exercise") ||
      cleaned.includes("workout") ||
      cleaned.includes("gym")
    ) {
      return knowledgeBase[5].response;
    }

    if (
      cleaned.includes("contact") ||
      cleaned.includes("doctor") ||
      cleaned.includes("provider") ||
      cleaned.includes("support")
    ) {
      return knowledgeBase[4].response;
    }

    if (
      cleaned.includes("prescription") ||
      cleaned.includes("medicine") ||
      cleaned.includes("medication")
    ) {
      return knowledgeBase[3].response;
    }

    if (
      cleaned.includes("password") ||
      cleaned.includes("settings") ||
      cleaned.includes("profile") ||
      cleaned.includes("personal details")
    ) {
      return knowledgeBase[9].response;
    }

    if (
      cleaned.includes("vitals") ||
      cleaned.includes("biomarker") ||
      cleaned.includes("health metrics") ||
      cleaned.includes("blood pressure") ||
      cleaned.includes("heart rate")
    ) {
      return knowledgeBase[10].response;
    }

    // Fuse fallback
    const results = fuse.search(cleaned);

    if (results.length > 0 && results[0].score < 0.4) {
      return results[0].item.response;
    }

    return "You can ask me about navigating the app, managing appointments, or general health tips.";
  };

  return (
    <div className="assistant-dashboard page-enter">
      <div className="assistant-dashboard-inner tab-animate">
        <div className="page-header">
          <p className="page-label purple">SUPPORT</p>
          <h1>Health Assistant</h1>
          <p className="page-subtext">
            Chat with your AI health assistant here
          </p>
        </div>
        <div className="assistant-wrapper">
          <div className="assistant-card">
            {/* Header */}
            <div className="assistant-header">
              <div className="assistant-icon">
                <Bot size={22} />
              </div>
              <h2 style={{ fontWeight: 20 }}>HEALIX Bot</h2>
            </div>

            {/* Chat Area */}
            <div className="assistant-messages" ref={messagesContainerRef}>
              {messages.map((msg, index) => (
                <div
                  key={index}
                  className={msg.user ? "message user" : "message bot"}
                >
                  {msg.text}
                </div>
              ))}
              {isTyping && (
                <div className="message bot typing">Assistant is typing...</div>
              )}
            </div>

            {/* Input */}
            <div className="assistant-input">
              <input
                type="text"
                placeholder="Type your message..."
                value={input}
                onChange={(e) => setInput(e.target.value)}
                onKeyDown={(e) => e.key === "Enter" && handleSend()}
              />
              <button
                onClick={handleSend}
                disabled={!input.trim()}
                className={input.trim() ? "active" : ""}
              >
                <Send size={18} />
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Assistant;
