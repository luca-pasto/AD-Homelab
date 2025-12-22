import requests
import time
import os
from bs4 import BeautifulSoup

HEADER = {"User-Agent": "Mozilla/5.0"}

html = requests.get("https://www.espn.com/nba/teams",headers=HEADER).text
soup = BeautifulSoup(html, "html.parser")

# For loop to get each team roster link saved into the team_url variable.
team_urls = set() 
for a in soup.select('a[href^="/nba/team/_/name/"]'):
    team_urls.add("https://www.espn.com" + a["href"].replace("/nba/team/_/", "/nba/team/roster/_/"))

players = set()
for url in team_urls:
    team_roster = requests.get(url, headers=HEADER).text
    roster_soup = BeautifulSoup(team_roster,"html.parser")

    #Gets each name from the roster and adjusts the format for later use.
    for player in roster_soup.find_all("a", attrs={"data-resource-id" : "AthleteName"}):
        name = player.get_text(strip=True)
        name = name.replace("'", "").replace(".", "")
        for suffix in ["Jr", "II", "III", "IV"]:
            if name.endswith(" " + suffix):
                name = name.replace(" " + suffix, "")
        players.add(name)
    time.sleep(1)

#Write the .txt to the user's desktop
desktop_path = os.path.join(os.path.expanduser("~"), "Desktop")
file_path = os.path.join(desktop_path, "names.txt")
with open(file_path, "w", encoding="utf-8") as file:
    for name in players:
        file.write(name+"\n")
print(f"File saved to {file_path}")
