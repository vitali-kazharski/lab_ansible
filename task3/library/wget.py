import urllib.request
import os
import hashlib
import requests
from ansible.module_utils.basic import *


def main():
    module = AnsibleModule(
        argument_spec=dict(
            src=dict(required=True, type='str'),
            dest=dict(required=True, type='str'),
            checksum=dict(required=False, type='str'),
            group=dict(required=False, type='str'),
            owner=dict(required=False, type='str'),
            mode=dict(required=False, type='str')
        )
    )
    checksum = module.params['checksum']
    src = module.params['src']
    dest = module.params['dest']
    file_path = file_dest(dest, src)
    if checksum:
        if checksum.split(":")[1] == remote_hash(src, checksum.split(":")[0]):
            if os.path.exists(file_path):
                if local_hash(file_path) == remote_hash(src):
                    module.exit_json(changed=False)
                else:
                    download(src, file_path)
                    module.exit_json(changed=True)
            else:
                download(src, file_path)
                module.exit_json(changed=True)
        else:
            module.exit_json(failed=True, msg="Checksum does not match")
    else:
        if os.path.exists(file_path):
            if local_hash(file_path) == remote_hash(src):
                module.exit_json(changed=False)
            else:
                download(src, file_path)
                module.exit_json(changed=True)
        else:
            download(src, file_path)
            module.exit_json(changed=True)


def file_dest(dest, src):
    if os.path.isdir(dest):
        new_dest = f"{dest}/{src.split('/')[-1]}"
        return new_dest
    else:
        return dest


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


def remote_hash(remote, algorithm="md5"):
    r = requests.get(remote)
    if algorithm == "md5":
        hash = hashlib.md5()
    elif algorithm == "sha1":
        hash = hashlib.sha1()
    elif algorithm == "sha256":
        hash = hashlib.sha256()
    elif algorithm == "sha384":
        hash = hashlib.sha384()
    elif algorithm == "sha512":
        hash = hashlib.sha512()
    for data in r.iter_content(8192):
        hash.update(data)
    return hash.hexdigest()


def download(src, dest):
    with urllib.request.urlopen(src) as response, open(dest, 'wb') as out_file:
        data = response.read()  # a `bytes` object
        out_file.write(data)

def check_exist(file, src):
    if os.path.exists(file_path):
        if local_hash(file_path) == remote_hash(src):
            return False
        else:
            download(src, file_path)
            return True
    else:
        download(src, file_path)
        return True

if __name__ == '__main__':
    main()
