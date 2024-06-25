import gdown

def get_google_drive_url(file_id):
    url = gdown.get_url(f"https://drive.google.com/uc?id={file_id}")
    return url

if __name__ == "__main__":
    file_id = "YOUR_FILE_ID_HERE"  # Replace with your Google Drive file ID
    direct_download_url = get_google_drive_url(file_id)
    print("Direct Download URL:", direct_download_url)
