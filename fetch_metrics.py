import requests
import yaml

# GitHub repository details
owner = "coozila"
repo = "dragonflydb"
url = f"https://api.github.com/repos/{owner}/{repo}"

# Fetch repository data
response = requests.get(url)
data = response.json()

# Extract required metrics
metrics = {
    'stars': data.get('stargazers_count', 0),
    'forks': data.get('forks_count', 0),
    'open_issues': data.get('open_issues_count', 0),
    'downloads': 0  # This will be handled separately if you track downloads as assets
}

# Fetch release data for download counts
releases_url = f"{url}/releases"
releases_response = requests.get(releases_url)
releases = releases_response.json()

total_downloads = 0
for release in releases:
    for asset in release.get('assets', []):
        total_downloads += asset.get('download_count', 0)

metrics['downloads'] = total_downloads

# Save metrics to YAML file
with open('metrics.yml', 'w') as file:
    yaml.dump(metrics, file)

print(f"Metrics: {metrics}")
