import gdown

url = 'https://drive.google.com/file/d/1EwiMessgpAOzgUnYy_9xEAActXHAiMAw/view?usp=drive_link'
output = '.\Temp'
gdown.download(url, output, quiet=False)