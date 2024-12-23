import requests
import yaml

# Detalii despre repository
repo = "coozila/dragonflydb"
url = f"https://api.github.com/repos/{repo}/releases"

# Obține toate release-urile
response = requests.get(url)
releases = response.json()

total_downloads = 0

# Parcurge fiecare release și adună numărul de descărcări
for release in releases:
    for asset in release['assets']:
        total_downloads += asset['download_count']

# Scrie numărul total de descărcări în downloads.yml
with open('downloads.yml', 'w') as file:
    yaml.dump({'downloads': {'total': total_downloads}}, file)

print(f"Total Downloads: {total_downloads}")
