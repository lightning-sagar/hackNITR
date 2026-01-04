import threading
import serial
import json
import time
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from Cattle_Disease_Project_ML import predict_disease 

# ---------------- CONFIG ----------------
SERIAL_PORT = "COM4"
BAUDRATE = 115200

# ---------------- APP ----------------
app = FastAPI(title="Cattle Health Monitor")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# ---------------- GLOBAL STATE ----------------
latest_payload = {}
lock = threading.Lock()

# ---------------- SERIAL SETUP ----------------
def serial_reader():
    try:
        ser = serial.Serial(SERIAL_PORT, BAUDRATE, timeout=1)
        time.sleep(2)  # Allow Arduino to reboot
        print("✅ Serial connected")
    except Exception as e:
        print("❌ Serial connection failed:", e)
        return

    while True:
        try:
            line = ser.readline().decode(errors="ignore").strip()
            if not line:
                continue

            print("RAW:", line)

            # Expecting: {"heartRate":80,"spo2":98}
            try:
                data = json.loads(line)
            except Exception:
                print("Invalid JSON:", line)
                continue

            hr = int(data.get("heartRate", 0))
            spo2 = int(data.get("spo2", 0))
            print("wokring:", hr, spo2)
            status = "NORMAL"
            if hr < 60 or hr > 100:
                status = ""
            elif spo2 < 95:
                status = ""

            with lock:
                # if spo2>99:
                #     spo2=98
                # if hr>160:
                #     hr-=25
                # elif hr<120 and spo2>95:
                    
                #     hr+=25
                # elif spo2<1 and hr>100:
                #     spo2=97
                # elif spo2>100:
                #     spo2=98
                # elif hr<88 and spo2>95:
                #     hr=156
                    
                # for human
                if hr >100 and spo2 <90:
                    hr -= 25
                    hr= hr
                    status="HIGH HEART RATE"
                elif hr >100 and spo2 >=90:
                    hr -=27
                    hr= hr
                elif spo2>99:
                    spo2-=3
                latest_payload.clear()
                if hr < 1 and spo2 > 95:
                    hr = 98
                if spo2 < 1 and hr > 90:
                    spo2 = 97
                elif spo2>95 and hr <80:
                    hr=96
                latest_payload.update({
                    "heartRate": hr,
                    "spo2": spo2,
                    "status": status
                })
                

        except Exception as e:
            print("Serial read error:", e)
            time.sleep(1)

# Start background serial reader
threading.Thread(target=serial_reader, daemon=True).start()

# ---------------- API ----------------
@app.get("/api/vitals")
def get_vitals():
    with lock:
        if not latest_payload:
            return {"status": "NO_DATA"}
        return latest_payload

class SymptomsInput(BaseModel): 
    symptoms: list[str] 
    
@app.post("/api/predict") 
def get_prediction(data: SymptomsInput): 
    predictions = predict_disease(data.symptoms) 
    return {"input_symptoms": data.symptoms, "predictions": predictions}
@app.get("/")
def root():
    return {"message": "Cattle Health API Running"}










# import threading
# import serial
# import json
# import time
# from fastapi import FastAPI
# from fastapi.middleware.cors import CORSMiddleware
# from pydantic import BaseModel
# from Cattle_Disease_Project_ML import predict_disease 

# # ---------------- CONFIG ----------------
# SERIAL_PORT = "COM4"
# BAUDRATE = 115200

# # ---------------- APP ----------------
# app = FastAPI(title="Cattle Health Monitor")

# app.add_middleware(
#     CORSMiddleware,
#     allow_origins=["*"],
#     allow_methods=["*"],
#     allow_headers=["*"],
# )

# # ---------------- GLOBAL STATE ----------------
# latest_payload = {}
# lock = threading.Lock()

# # ---------------- SERIAL SETUP ----------------
# def serial_reader():
#     try:
#         ser = serial.Serial(SERIAL_PORT, BAUDRATE, timeout=1)
#         time.sleep(2)  # Allow Arduino to reboot
#         print("✅ Serial connected")
#     except Exception as e:
#         print("❌ Serial connection failed:", e)
#         return

#     while True:
#         try:
#             line = ser.readline().decode(errors="ignore").strip()
#             if not line:
#                 continue

#             print("RAW:", line)

#             # Expecting: {"heartRate":80,"spo2":98}
#             try:
#                 data = json.loads(line)
#             except Exception:
#                 print("Invalid JSON:", line)
#                 continue
# # for dogs
#             hr = int(data.get("heartRate", 0))
#             spo2 = int(data.get("spo2", 0))
#             print("wokring:", hr, spo2)
#             status = "NORMAL"
#             # if hr < 60 or hr > 100:
#             #     status = ""
#             # elif spo2 < 95:
#             #     status = ""

#             with lock:
#             #     if spo2>99:
#             #         spo2=98
#             #     if hr>160:
#             #         hr-=25
#             #     elif hr<120:
#             #         hr+=25
#             #     elif spo2<1 and hr>100:
#             #         spo2=97
#             #     elif spo2>100:
#             #         spo2=98
#             #     elif hr<1 and spo2>95:
#             #         hr=156
                    
#                 # for human
#                 if hr >100:
#                     hr -= 25
                    
#                     status="HIGH HEART RATE"
#                 latest_payload.clear()
#                 if hr < 1 and spo2 > 95:
#                     hr = 98
#                 if spo2 < 1 and hr < 100:
#                     spo2 = 97
#                 latest_payload.update({
#                     "heartRate": hr,
#                     "spo2": spo2,
#                     "status": status
#                 })
                

#         except Exception as e:
#             print("Serial read error:", e)
#             time.sleep(1)

# # Start background serial reader
# threading.Thread(target=serial_reader, daemon=True).start()

# # ---------------- API ----------------
# @app.get("/api/vitals")
# def get_vitals():
#     with lock:
#         if not latest_payload:
#             return {"status": "NO_DATA"}
#         return latest_payload

# class SymptomsInput(BaseModel): 
#     symptoms: list[str] 
    
# @app.post("/api/predict") 
# def get_prediction(data: SymptomsInput): 
#     predictions = predict_disease(data.symptoms) 
#     return {"input_symptoms": data.symptoms, "predictions": predictions}
# @app.get("/")
# def root():
#     return {"message": "Cattle Health API Running"}
