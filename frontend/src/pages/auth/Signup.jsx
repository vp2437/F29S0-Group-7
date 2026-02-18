import { useNavigate } from "react-router-dom";

export const Signup = () => {
  const navigate = useNavigate();

  return (
    <div
      style={{
        minHeight: "100vh",
        display: "flex",
        alignItems: "center",
        justifyContent: "center",
        background: "#0f172a",
        fontFamily: "'DM Sans', sans-serif",
      }}
    >
      <div
        style={{
          background: "#1e293b",
          border: "1px solid #334155",
          padding: "40px",
          borderRadius: "16px",
          width: "400px",
          boxShadow: "0 25px 50px rgba(0,0,0,0.4)",
        }}
      >
        {/* Logo */}
        <div
          style={{
            display: "flex",
            alignItems: "center",
            gap: "10px",
            marginBottom: "28px",
          }}
        >
          <div
            style={{
              width: "36px",
              height: "36px",
              borderRadius: "9px",
              background: "linear-gradient(135deg, #3b82f6, #06b6d4)",
              display: "flex",
              alignItems: "center",
              justifyContent: "center",
              fontWeight: "800",
              fontSize: "14px",
              color: "#fff",
            }}
          >
            Hx
          </div>
          <span
            style={{
              color: "#f1f5f9",
              fontWeight: "700",
              fontSize: "18px",
              letterSpacing: "-0.3px",
            }}
          >
            HEALIX
          </span>
        </div>

        <h2
          style={{
            fontSize: "24px",
            fontWeight: "700",
            color: "#f1f5f9",
            margin: "0 0 6px 0",
            letterSpacing: "-0.4px",
          }}
        >
          Create Account
        </h2>
        <p
          style={{
            color: "#64748b",
            fontSize: "14px",
            margin: "0 0 28px 0",
          }}
        >
          Start your health journey with HEALIX
        </p>

        <input
          type="text"
          placeholder="Full Name"
          style={{
            width: "100%",
            marginBottom: "12px",
            padding: "12px 14px",
            border: "1px solid #334155",
            borderRadius: "8px",
            background: "#0f172a",
            color: "#f1f5f9",
            fontSize: "14px",
            outline: "none",
            boxSizing: "border-box",
          }}
        />
        <input
          type="email"
          placeholder="you@example.com"
          style={{
            width: "100%",
            marginBottom: "12px",
            padding: "12px 14px",
            border: "1px solid #334155",
            borderRadius: "8px",
            background: "#0f172a",
            color: "#f1f5f9",
            fontSize: "14px",
            outline: "none",
            boxSizing: "border-box",
          }}
        />
        <input
          type="password"
          placeholder="Password"
          style={{
            width: "100%",
            marginBottom: "24px",
            padding: "12px 14px",
            border: "1px solid #334155",
            borderRadius: "8px",
            background: "#0f172a",
            color: "#f1f5f9",
            fontSize: "14px",
            outline: "none",
            boxSizing: "border-box",
          }}
        />

        <button
          style={{
            width: "100%",
            background: "linear-gradient(135deg, #3b82f6, #06b6d4)",
            color: "#fff",
            padding: "11px",
            borderRadius: "8px",
            border: "none",
            fontWeight: "600",
            fontSize: "14px",
            cursor: "pointer",
          }}
        >
          Create Account
        </button>

        <p
          style={{
            textAlign: "center",
            marginTop: "20px",
            fontSize: "13px",
            color: "#64748b",
          }}
        >
          Already have an account?{" "}
          <a
            href="/login"
            style={{ color: "#60a5fa", textDecoration: "none" }}
          >
            Log in
          </a>
        </p>
      </div>
    </div>
  );
};
