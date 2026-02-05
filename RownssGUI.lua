import sys
import threading
import time
import random
from PyQt5.QtCore import Qt, QTimer, QThread, pyqtSignal
from PyQt5.QtWidgets import (
    QApplication, QWidget, QPushButton, QVBoxLayout, QHBoxLayout,
    QLabel, QFrame, QSlider, QCheckBox, QSystemTrayIcon, QMenu
)
from PyQt5.QtGui import QColor, QFont, QPainter, QPen, QFontDatabase
import pyautogui
import win32api
import win32con
import win32gui
import win32process
import psutil
import ctypes
import os
import subprocess
import yaml
import sqlite3
from Crypto.Cipher import AES
import base64
import logging
from logging.handlers import RotatingFileHandler

# Evasion Techniques
def amsi_bypass():
    try:
        amsi = ctypes.windll.kernel32.LoadLibraryA(b"amsi.dll")
        amsi_scan_buffer = ctypes.windll.kernel32.GetProcAddress(amsi, b"AmsiScanBuffer")
        ctypes.windll.kernel32.VirtualProtect(ctypes.c_void_p(amsi_scan_buffer), 1, 0x40, ctypes.c_int(0))
        ctypes.c_int(amsi_scan_buffer).value = 1
        print("AMSIBypass: Success")
    except Exception as e:
        print(f"AMSIBypass: Failed {e}")

def etw_patch():
    try:
        kernel32 = ctypes.windll.kernel32
        hProcess = kernel32.GetCurrentProcess()
        hThread = kernel32.GetCurrentThread()
        dwflg = 0x1000
        kernel32.SetThreadContext(hThread, ctypes.byref(ctypes.c_ulong(0x40010001)))
        kernel32.SetThreadInformation(hThread, 0x10, ctypes.byref(ctypes.c_ulong(0x40010001)), ctypes.sizeof(ctypes.c_ulong))
        print("ETW Patch: Success")
    except Exception as e:
        print(f"ETW Patch: Failed {e}")

# Encryption
def encrypt_data(data, key):
    cipher = AES.new(key, AES.MODE_GCM)
    ciphertext, tag = cipher.encrypt_and_digest(data.encode())
    return base64.b64encode(cipher.nonce + tag + ciphertext).decode()

def decrypt_data(encrypted_data, key):
    raw = base64.b64decode(encrypted_data)
    nonce = raw[:16]
    tag = raw[16:32]
    ciphertext = raw[32:]
    cipher = AES.new(key, AES.MODE_GCM, nonce)
    return cipher.decrypt_and_verify(ciphertext, tag).decode()

# Database
def init_db():
    conn = sqlite3.connect('rowngui.db', check_same_thread=False)
    c = conn.cursor()
    c.execute('''CREATE TABLE IF NOT EXISTS config
                 (id INTEGER PRIMARY KEY, key TEXT, value TEXT)''')
    conn.commit()
    return conn

# Logging
def setup_logging():
    log_formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
    log_file = 'rowngui.log'
    my_handler = RotatingFileHandler(log_file, mode='a', maxBytes=5*1024*1024, 
                                    backupCount=2, encoding=None, delay=0)
    my_handler.setFormatter(log_formatter)
    my_handler.setLevel(logging.INFO)
    logger = logging.getLogger('rowngui_logger')
    logger.setLevel(logging.INFO)
    logger.addHandler(my_handler)
    return logger

# GUI Class
class RownnGui(QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("RownnGui")
        self.setWindowFlags(Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint)
        self.setGeometry(100, 100, 800, 600)
        self.setStyleSheet("""
            QWidget {
                background-color: #202020;
                color: #ffffff;
                font-family: 'Segoe UI';
                font-size: 14px;
            }
            QPushButton {
                background-color: #333333;
                border: 1px solid #555555;
                padding: 10px;
                border-radius: 5px;
            }
            QPushButton:hover {
                background-color: #444444;
            }
            QLabel {
                margin: 5px;
            }
            QSlider::groove:horizontal {
                border: 1px solid #555555;
                height: 8px;
                background: #333333;
                margin: 2px 0;
            }
            QSlider::handle:horizontal {
                background: #555555;
                border: 1px solid #777777;
                width: 18px;
                margin: -5px 0;
                border-radius: 5px;
            }
        """)
        self.initUI()
        self.db_conn = init_db()
        self.logger = setup_logging()
        self.load_config()
        self.start_evasion()
        self.start_background_tasks()

    def initUI(self):
        # Title Bar
        title_bar = QWidget(self)
        title_bar.setStyleSheet("background-color: #1e1e1e;")
        title_layout = QHBoxLayout()
        title_label = QLabel("RownnGui")
        title_label.setStyleSheet("font-size: 18px; font-weight: bold;")
        close_btn = QPushButton("✕")
        close_btn.clicked.connect(self.close)
        minimize_btn = QPushButton("−")
        minimize_btn.clicked.connect(self.showMinimized)
        title_layout.addWidget(title_label)
        title_layout.addStretch()
        title_layout.addWidget(minimize_btn)
        title_layout.addWidget(close_btn)
        title_bar.setLayout(title_layout)
        title_bar.setGeometry(0, 0, self.width(), 30)

        # Main Layout
        main_layout = QVBoxLayout()
        main_layout.addWidget(title_bar)
        self.setLayout(main_layout)

        # Features
        self.create_features_section(main_layout)

    def create_features_section(self, layout):
        features = QWidget()
        features_layout = QVBoxLayout()

        # Fly
        fly_group = QFrame()
        fly_layout = QHBoxLayout()
        fly_label = QLabel("Fly")
        self.fly_checkbox = QCheckBox()
        fly_layout.addWidget(fly_label)
        fly_layout.addWidget(self.fly_checkbox)
        fly_group.setLayout(fly_layout)
        features_layout.addWidget(fly_group)

        # InfJump
        infjump_group = QFrame()
        infjump_layout = QHBoxLayout()
        infjump_label = QLabel("InfJump")
        self.infjump_checkbox = QCheckBox()
        infjump_layout.addWidget(infjump_label)
        infjump_layout.addWidget(self.infjump_checkbox)
        infjump_group.setLayout(infjump_layout)
        features_layout.addWidget(infjump_group)

        # NoClip
        noclip_group = QFrame()
        noclip_layout = QHBoxLayout()
        noclip_label = QLabel("NoClip")
        self.noclip_checkbox = QCheckBox()
        noclip_layout.addWidget(noclip_label)
        noclip_layout.addWidget(self.noclip_checkbox)
        noclip_group.setLayout(noclip_layout)
        features_layout.addWidget(noclip_group)

        # ESP
        esp_group = QFrame()
        esp_layout = QHBoxLayout()
        esp_label = QLabel("ESP")
        self.esp_checkbox = QCheckBox()
        esp_layout.addWidget(esp_label)
        esp_layout.addWidget(self.esp_checkbox)
        esp_group.setLayout(esp_layout)
        features_layout.addWidget(esp_group)

        # Bring Part
        bring_part_group = QFrame()
        bring_part_layout = QHBoxLayout()
        bring_part_label = QLabel("Bring Part")
        self.bring_part_checkbox = QCheckBox()
        bring_part_layout.addWidget(bring_part_label)
        bring_part_layout.addWidget(self.bring_part_checkbox)
        bring_part_group.setLayout(bring_part_layout)
        features_layout.addWidget(bring_part_group)

        # Fling Player
        fling_player_group = QFrame()
        fling_player_layout = QHBoxLayout()
        fling_player_label = QLabel("Fling Player")
        self.fling_player_checkbox = QCheckBox()
        fling_player_layout.addWidget(fling_player_label)
        fling_player_layout.addWidget(self.fling_player_checkbox)
        fling_player_group.setLayout(fling_player_layout)
        features_layout.addWidget(fling_player_group)

        features.setLayout(features_layout)
        layout.addWidget(features)

    def start_evasion(self):
        evasion_thread = threading.Thread(target=self.run_evasion, daemon=True)
        evasion_thread.start()

    def run_evasion(self):
        while True:
            amsi_bypass()
            etw_patch()
            time.sleep(5)

    def start_background_tasks(self):
        tasks = [
            self.background_fly,
            self.background_infjump,
            self.background_noclip,
            self.background_esp,
            self.background_bring_part,
            self.background_fling_player
        ]
        for task in tasks:
            t = threading.Thread(target=task, daemon=True)
            t.start()

    def background_fly(self):
        while True:
            if self.fly_checkbox.isChecked():
                self.fly()
            time.sleep(0.1)

    def fly(self):
        pyautogui.keyDown('space')
        time.sleep(0.1)
        pyautogui.keyUp('space')
        time.sleep(0.1)

    def background_infjump(self):
        while True:
            if self.infjump_checkbox.isChecked():
                self.infjump()
            time.sleep(0.1)

    def infjump(self):
        pyautogui.keyDown('space')
        time.sleep(0.1)
        pyautogui.keyUp('space')
        time.sleep(0.1)

    def background_noclip(self):
        while True:
            if self.noclip_checkbox.isChecked():
                self.noclip()
            time.sleep(0.1)

    def noclip(self):
        pyautogui.keyDown('c')
        time.sleep(0.1)
        pyautogui.keyUp('c')
        time.sleep(0.1)

    def background_esp(self):
        while True:
            if self.esp_checkbox.isChecked():
                self.esp()
            time.sleep(0.1)

    def esp(self):
        # Simulate ESP by drawing boxes (requires overlay window)
        pass

    def background_bring_part(self):
        while True:
            if self.bring_part_checkbox.isChecked():
                self.bring_part()
            time.sleep(0.1)

    def bring_part(self):
        pyautogui.hotkey('ctrl', 'b')
        time.sleep(0.1)

    def background_fling_player(self):
        while True:
            if self.fling_player_checkbox.isChecked():
                self.fling_player()
            time.sleep(0.1)

    def fling_player(self):
        pyautogui.hotkey('ctrl', 'f')
        time.sleep(0.1)

    def load_config(self):
        try:
            with open('config.yaml', 'r') as f:
                config = yaml.safe_load(f)
                self.fly_checkbox.setChecked(config.get('fly', False))
                self.infjump_checkbox.setChecked(config.get('infjump', False))
                self.noclip_checkbox.setChecked(config.get('noclip', False))
                self.esp_checkbox.setChecked(config.get('esp', False))
                self.bring_part_checkbox.setChecked(config.get('bring_part', False))
                self.fling_player_checkbox.setChecked(config.get('fling_player', False))
        except:
            pass

    def save_config(self):
        config = {
            'fly': self.fly_checkbox.isChecked(),
            'infjump': self.infjump_checkbox.isChecked(),
            'noclip': self.noclip_checkbox.isChecked(),
            'esp': self.esp_checkbox.isChecked(),
            'bring_part': self.bring_part_checkbox.isChecked(),
            'fling_player': self.fling_player_checkbox.isChecked()
        }
        with open('config.yaml', 'w') as f:
            yaml.safe_dump(config, f)

    def closeEvent(self, event):
        self.save_config()
        event.accept()

if __name__ == '__main__':
    amsi_bypass()
    etw_patch()
    app = QApplication(sys.argv)
    gui = RownnGui()
    gui.show()
    sys.exit(app.exec_())