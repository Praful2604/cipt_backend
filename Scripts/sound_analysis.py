import sounddevice as sd
import numpy as np
import tkinter as tk
from tkinter import ttk
import threading
import queue
import time

# ------------------------------
# Global variables
# ------------------------------
samplerate = 16000
channels = 1
running = False
audio_q = queue.Queue()
recorded_audio = []

# ------------------------------
# Audio callback (collects chunks while recording)
# ------------------------------
def audio_callback(indata, frames, time_info, status):
    if running:
        audio_q.put(indata.copy())

# ------------------------------
# Record audio in background
# ------------------------------
def record_audio():
    global recorded_audio
    recorded_audio = []
    with sd.InputStream(samplerate=samplerate, channels=channels, callback=audio_callback):
        while running:
            while not audio_q.empty():
                recorded_audio.append(audio_q.get())
            time.sleep(0.1)

# ------------------------------
# Safe FFT-based pitch detection (no crash)
# ------------------------------
def safe_pitch_fft(y, sr):
    try:
        window = np.hanning(len(y))
        spectrum = np.fft.rfft(y * window)
        freqs = np.fft.rfftfreq(len(y), 1/sr)
        magnitude = np.abs(spectrum)
        freq = freqs[np.argmax(magnitude[1:])]  # skip DC
        return freq
    except Exception:
        return 0.0

# ------------------------------
# Analyze the recorded audio
# ------------------------------
def analyze_audio(audio_data):
    y = np.concatenate(audio_data, axis=0).flatten()
    if np.max(np.abs(y)) == 0:
        return "❌ No sound detected.", "", ""

    y = y / (np.max(np.abs(y)) + 1e-9)

    # --- Pitch ---
    mid = len(y) // 2
    segment = y[mid - samplerate : mid + samplerate] if len(y) > 2 * samplerate else y
    if np.any(np.abs(segment) > 1e-3):
        pitch = safe_pitch_fft(segment, samplerate)
    else:
        pitch = 0.0

    # --- Volume ---
    volume = float(np.mean(np.abs(y)))

    # --- Speech rate (rough estimate) ---
    energy = np.abs(y)
    energy_threshold = 0.02
    voiced_frames = np.sum(energy > energy_threshold)
    speech_rate = (voiced_frames / samplerate) * 180  # approx words/min

    # --- Feedback ---
    if pitch > 250:
        pitch_fb = "🎵 Your pitch is high. Try speaking in a lower tone."
    elif pitch < 100 and pitch != 0:
        pitch_fb = "🎵 Your pitch is low. Try speaking more clearly."
    else:
        pitch_fb = "🎵 Pitch sounds normal."

    if volume < 0.01:
        volume_fb = "🔈 You're speaking softly."
    elif volume > 0.3:
        volume_fb = "🔊 You're speaking loudly."
    else:
        volume_fb = "🔉 Volume is balanced."

    if speech_rate > 180:
        rate_fb = "⚡ You're speaking too fast!"
    elif speech_rate < 80:
        rate_fb = "🐢 You're speaking slowly."
    else:
        rate_fb = "✅ Good speaking pace."

    return pitch_fb, volume_fb, rate_fb

# ------------------------------
# GUI control functions
# ------------------------------
def start_recording():
    global running
    if not running:
        running = True
        status_label.config(text="🎙 Recording... Speak now")
        result_label.config(text="")
        threading.Thread(target=record_audio, daemon=True).start()

def stop_recording():
    global running
    if running:
        running = False
        status_label.config(text="⏹ Recording stopped. Analyzing...")
        window.update()
        time.sleep(1)

        if len(recorded_audio) == 0:
            result_label.config(text="❌ No audio detected.")
            status_label.config(text="Recording failed — try again.")
            return

        pitch_fb, volume_fb, rate_fb = analyze_audio(recorded_audio)
        result_label.config(text=f"{pitch_fb}\n{volume_fb}\n{rate_fb}")
        status_label.config(text="✅ Analysis Complete")

# ------------------------------
# GUI setup
# ------------------------------
window = tk.Tk()
window.title("Voice Feedback Tool")
window.geometry("550x350")

title_label = ttk.Label(window, text="🎧 Speak and Get Feedback", font=("Arial", 18, "bold"))
title_label.pack(pady=15)

status_label = ttk.Label(window, text="Press 'Start' to begin speaking.", font=("Arial", 13))
status_label.pack(pady=10)

start_btn = ttk.Button(window, text="🎙 Start Recording", command=start_recording)
start_btn.pack(pady=5)

stop_btn = ttk.Button(window, text="⏹ Stop & Analyze", command=stop_recording)
stop_btn.pack(pady=5)

result_label = ttk.Label(window, text="", font=("Arial", 12), wraplength=500, justify="center")
result_label.pack(pady=20)

window.mainloop()
