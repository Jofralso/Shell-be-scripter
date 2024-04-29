# Developer: Francisco Soares
# Contact: dev.jquico@gmail.com
# Description: This script scrapes images recursively from a website and saves them to the local directory.

import os
import sys
import requests
from bs4 import BeautifulSoup
from urllib.parse import urlparse, urljoin

def create_folder(title):
    """
    Create a folder with the specified title if it doesn't exist.

    Args:
        title (str): Title of the folder.

    Returns:
        str: Name of the created folder.
    """
    folder_name = title.strip().replace(' ', '_')
    os.makedirs(folder_name, exist_ok=True)
    return folder_name

def download_image(image_url, folder_name):
    """
    Download an image from the specified URL and save it to the specified folder.

    Args:
        image_url (str): URL of the image to download.
        folder_name (str): Name of the folder to save the image.

    """
    try:
        image_response = requests.get(image_url)
        image_response.raise_for_status()
        image_name = os.path.basename(urlparse(image_url).path)
        with open(os.path.join(folder_name, image_name), 'wb') as f:
            f.write(image_response.content)
            print(f"Downloaded: {image_name}")
    except Exception as e:
        print(f"Failed to download image from {image_url}: {e}")

def scrape_images(url, visited_links=set()):
    """
    Scrape images recursively from the specified URL and its subpages.

    Args:
        url (str): URL of the webpage to scrape.
        visited_links (set): Set to keep track of visited URLs.

    """
    try:
        response = requests.get(url)
        response.raise_for_status()
        soup = BeautifulSoup(response.text, 'html.parser')
        
        # Get the title of the webpage
        title = soup.title.string if soup.title else "Untitled"
        folder_name = create_folder(title)

        # Find all image tags and extract their source URLs
        image_tags = soup.find_all('img')
        image_urls = [urljoin(url, img['src']) for img in image_tags if 'src' in img.attrs]

        # Download each image
        for image_url in image_urls:
            download_image(image_url, folder_name)

        # Find all links on the page and recursively scrape them
        links = soup.find_all('a', href=True)
        for link in links:
            absolute_link = urljoin(url, link['href'])
            if absolute_link not in visited_links and absolute_link.startswith(url):
                visited_links.add(absolute_link)
                scrape_images(absolute_link, visited_links)

    except Exception as e:
        print(f"Failed to scrape images from {url}: {e}")

if __name__ == "__main__":
    # Check if the correct number of arguments is provided
    if len(sys.argv) != 2:
        print("Usage: python script.py <url>")
        sys.exit(1)

    url = sys.argv[1]
    scrape_images(url)
