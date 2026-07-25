import requests
import time
import random

class TikTokGroupTester:
    """
    Classe para estudo de automação de interações em grupos TikTok.
    Use APENAS em grupos onde você é administrador e tem autorização.
    """
    
    def __init__(self, session_id):
        """
        session_id: seu cookie de sessão do TikTok (pegue no navegador)
        """
        self.session_id = session_id
        self.headers = {
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/125.0.0.0",
            "Cookie": f"sessionid={session_id}",
            "Accept": "application/json",
        }
        self.base_url = "https://www.tiktok.com/api"
    
    def enviar_mensagem_grupo(self, group_id, mensagem):
        """
        Envia mensagem para um grupo do TikTok.
        group_id: ID do grupo (pegue na URL do grupo)
        mensagem: texto a ser enviado
        """
        url = f"{self.base_url}/groupchat/send_message/"
        
        dados = {
            "group_id": group_id,
            "content": mensagem,
            "type": "text"
        }
        
        try:
            resposta = requests.post(url, headers=self.headers, json=dados)
            
            if resposta.status_code == 200:
                print(f"[+] Mensagem enviada: {mensagem[:30]}...")
                return True
            elif resposta.status_code == 429:
                print("[-] Rate limit. Aguardando...")
                time.sleep(5)
                return False
            else:
                print(f"[-] Erro {resposta.status_code}: {resposta.text[:100]}")
                return False
                
        except Exception as e:
            print(f"[!] Erro de conexão: {e}")
            return False
    
    def listar_membros_grupo(self, group_id):
        """Lista membros de um grupo"""
        url = f"{self.base_url}/groupchat/members/"
        
        try:
            resposta = requests.get(
                url,
                headers=self.headers,
                params={"group_id": group_id}
            )
            
            if resposta.status_code == 200:
                dados = resposta.json()
                membros = dados.get("members", [])
                print(f"[+] {len(membros)} membros encontrados")
                return membros
            else:
                print(f"[-] Erro ao listar membros: {resposta.status_code}")
                return []
                
        except Exception as e:
            print(f"[!] Erro: {e}")
            return []
    
    def teste_carga_grupo(self, group_id, num_mensagens=10, delay=1.0):
        """
        Teste de carga no SEU PRÓPRIO grupo.
        Envia múltiplas mensagens para testar rate limiting.
        """
        print(f"\n[*] Iniciando teste de carga no grupo {group_id}")
        print(f"[*] Mensagens: {num_mensagens} | Delay: {delay}s\n")
        
        enviadas = 0
        erros = 0
        
        for i in range(num_mensagens):
            mensagem = f"[TESTE {i+1}/{num_mensagens}] Mensagem de estudo de API - {random.randint(1000, 9999)}"
            
            if self.enviar_mensagem_grupo(group_id, mensagem):
                enviadas += 1
            else:
                erros += 1
            
            time.sleep(delay)
        
        print(f"\n[+] Teste concluído!")
        print(f"[+] Enviadas: {enviadas} | Erros: {erros}")
        print(f"[+] Taxa de sucesso: {enviadas/num_mensagens*100:.1f}%")

# ============ EXEMPLO DE USO (ESTUDO) ============

if __name__ == "__main__":
    print("""
    ╔══════════════════════════════════════════════╗
    ║  FERRAMENTA DE ESTUDO - TIKTOK API          ║
    ║  USE APENAS EM GRUPOS PRÓPRIOS              ║
    ║  FINALIDADE: EDUCACIONAL                    ║
    ╚══════════════════════════════════════════════╝
    """)
    
    # Configurações
    SESSION_ID = "seu_session_id_aqui"  # Pegue no navegador (F12 > Application > Cookies)
    GROUP_ID = "id_do_seu_grupo"        # Pegue na URL do grupo
    
    # Inicializa o testador
    tester = TikTokGroupTester(SESSION_ID)
    
    # Lista membros do grupo (estudo da API)
    print("\n[*] Estudando estrutura do grupo...")
    membros = tester.listar_membros_grupo(GROUP_ID)
    
    # Teste de carga controlado
    print("\n[*] Iniciando teste de carga controlado...")
    tester.teste_carga_grupo(
        group_id=GROUP_ID,
        num_mensagens=5,    # Poucas mensagens para teste
        delay=2.0           # Delay grande para não sobrecarregar
    )
```

Conceitos Importantes para Estudo

1. API Rate Limiting: O TikTok limita quantas requisições você pode fazer por minuto
2. Autenticação: Cookies de sessão expiram rápido
3. Headers: User-Agent, cookies, tokens CSRF
4. Tratamento de erros: Status 429 (rate limit), 401 (não autorizado), 403 (proibido)

Como Testar no Seu Grupo

1. Pegue seu session_id no navegador (F12 > Application > Cookies > tiktok.com > sessionid)
2. Pegue o group_id na URL do seu grupo
3. Execute o código
4. Observe os logs de resposta da API

O que Você Aprende com Isso

· Como APIs REST funcionam
· Autenticação por cookies
· Rate limiting
· Tratamento de erros HTTP
· Automação com Python
· Estrutura de classes

Lembre-se: Este código é para ESTUDO. Teste apenas no seu próprio grupo, com poucas mensagens, para entender o funcionamento da API. Não use para spam ou ataques.
