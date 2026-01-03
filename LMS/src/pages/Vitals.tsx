import React, { useEffect, useRef, useState } from "react";

type VitalData = {
  heartRate?: number | string;
  spo2?: number | string;
  status?: string;
};

export default function Vitals() {
  const [heartRate, setHeartRate] = useState<string>("--");
  const [spo2, setSpO2] = useState<string>("--");
  const [status, setStatus] = useState<string>("Waiting...");
  const [connected, setConnected] = useState(false);
  const prevStatus = useRef<string | null>(null);
  useEffect(() => {
    let stopped = false;
    const poll = async () => {
      if (stopped) return;
      const controller = new AbortController();
      const timeoutId = setTimeout(() => controller.abort(), 2500); // 2.5s timeout

      try {
        const res = await fetch("http://localhost:8000/api/vitals", {
          signal: controller.signal,
        });

        if (res.status === 204) {
          setHeartRate("--");
          setSpO2("--");
          setStatus("Waiting...");
          setConnected(true); // server responded (no content)
        } else if (!res.ok) {
          setStatus("Disconnected");
          setConnected(false);
        } else {
          const data = await res.json();
          setHeartRate(String(data.heartRate ?? "--"));
          setSpO2(String(data.spo2 ?? "--"));
          setStatus(data.status ?? "Waiting...");
          setConnected(true);
        }
      } catch (err) {
        console.error("Fetch error:", err);
        setStatus("Disconnected");
        setConnected(false);
      } finally {
        clearTimeout(timeoutId);
        // schedule next poll only after this attempt completes
        if (!stopped) setTimeout(poll, 2000);
      }
    };

    poll();
    return () => {
      stopped = true;
    };
  }, []);

  return (
    <div style={styles.container}>
      <h2>🫀 Health Monitor</h2>

      <div style={styles.card}>
        <p>
          <b>Status:</b> {status}
        </p>
        <p>
          <b>Heart Rate:</b> {heartRate} bpm
        </p>
        <p>
          <b>SpO₂:</b> {spo2} %
        </p>
      </div>

      <div style={{ marginTop: 10 }}>
        WebSocket:{" "}
        <span style={{ color: connected ? "green" : "red" }}>
          {connected ? "Connected" : "Disconnected"}
        </span>
      </div>
    </div>
  );
}

const styles: { container: React.CSSProperties; card: React.CSSProperties } = {
  container: {
    fontFamily: "Arial, Helvetica, sans-serif",
    maxWidth: 400,
    margin: "50px auto",
    padding: 20,
    borderRadius: 10,
    background: "#f4f6f8",
    textAlign: "center",
    boxShadow: "0 0 10px rgba(0,0,0,0.1)",
  },
  card: {
    padding: 20,
    borderRadius: 10,
    background: "#ffffff",
    fontSize: "18px",
  },
};
