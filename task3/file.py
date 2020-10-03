import os
import hashlib
import requests
import urllib.request


def remote_hash(remote, algorithm="md5"):
    r = requests.get(remote)
    if algorithm=="md5":
        hash = hashlib.md5()
    elif algorithm=="sha1":
        hash = hashlib.sha1()
    elif algorithm=="sha256":
        hash = hashlib.sha256()
    elif algorithm=="sha384":
        hash = hashlib.sha384()
    elif algorithm=="sha512":
        hash = hashlib.sha512()
    for data in r.iter_content(8192):
        hash.update(data)
    return hash.hexdigest()
    

def local_hash(dest, algorithm="md5"):
    if algorithm == "md5":
        hash = hashlib.md5(open(dest, 'rb').read())
    elif algorithm == "sha1":
        hash = hashlib.sha1(open(dest, 'rb').read())
    elif algorithm == "sha256":
        hash = hashlib.sha256(open(dest, 'rb').read())
    elif algorithm == "sha384":
        hash = hashlib.sha384(open(dest, 'rb').read())
    elif algorithm == "sha512":
        hash = hashlib.sha512(open(dest, 'rb').read())
    return hash.hexdigest()

def download(src, dest):
    with urllib.request.urlopen(src) as response, open(dest, 'wb') as out_file:
            data = response.read()  # a `bytes` object
            out_file.write(data)

