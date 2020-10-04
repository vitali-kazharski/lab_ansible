#!/usr/bin/python

DOCUMENTATION = '''
---
module: wget

short_description: This is my wget module

version_added: "1.0.0"

description: Module for download files with test checksum

options:
    src:
        description: Url for download file
        required: true
        type: str
    dest:
        description: File or directory destination
        required: true
        type: str
    checksum:
        description: Checksum for compare before downloading
        required: false
        type: str
    owner:
        description: Set owner for downloaded file
        required: false
        type: str
    group:
        description: Set group for downloaded file
        required: false
        type: str
    mode:
        description: Set mode for downloaded file
        required: false
        type: int
author:
    - Ilya Melnik (Ilya_Melnik1@epam.com)
'''

EXAMPLES = '''

- name: Download Tomcat
    become: yes
    wget:
        src: https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.9/bin/apache-tomcat-8.5.9.tar.gz
        dest: ./file.tar.gz
        checksum: "sha1:3c800e7affdf93bf4dbcf44bd852904449b786f6"
        owner: nobody
        group: nogroup
        mode: 777
'''
from ansible.module_utils.basic import *
import grp
import pwd
import requests
import hashlib
import os
import urllib.request


def main():
    module = AnsibleModule(
        argument_spec=dict(
            src=dict(required=True, type='str'),
            dest=dict(required=True, type='str'),
            checksum=dict(required=False, type='str'),
            group=dict(required=False, type='str'),
            owner=dict(required=False, type='str'),
            mode=dict(required=False, type='int')
        )
    )
    src = module.params['src']
    dest = module.params['dest']
    checksum = module.params['checksum']
    owner = module.params['owner']
    group = module.params['group']
    mode = str(module.params['mode'])
    file_path = file_dest(dest, src)
    if checksum:
        if checksum.split(":")[1] == remote_hash(src, checksum.split(":")[0]):
            module.exit_json(changed=check_all(
                file_path, src, owner, group, mode))
        else:
            module.exit_json(failed=True, msg="Checksum does not match")
    else:
        module.exit_json(changed=check_all(file_path, src, owner, group, mode))


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


def check_all(file, src, owner=None, group=None, mode=None):
    if os.path.exists(file):
        ownerlist_false = [pwd.getpwuid(os.stat(file).st_uid).pw_name, None]
        grouplist_false = [grp.getgrgid(os.stat(file).st_gid).gr_name, None]
        modelist_false = [oct(os.stat(file).st_mode)[-4:],
                      oct(os.stat(file).st_mode)[-3:], 'None']
        if local_hash(file) == remote_hash(src):
            if owner not in ownerlist_false or group not in grouplist_false or mode not in modelist_false:
                return check_owner_group_mode(file, owner, group, mode)
            return False
        else:
            download(src, file)
            if owner not in ownerlist_false or group not in grouplist_false or mode not in modelist_false:
                return check_owner_group_mode(file, owner, group, mode)
            return True
    else:
        download(src, file)
        ownerlist_false = [pwd.getpwuid(os.stat(file).st_uid).pw_name, None]
        grouplist_false = [grp.getgrgid(os.stat(file).st_gid).gr_name, None]
        modelist_false = [oct(os.stat(file).st_mode)[-4:],
                      oct(os.stat(file).st_mode)[-3:], 'None']
        if owner not in ownerlist_false or group not in grouplist_false or mode not in modelist_false:
            return check_owner_group_mode(file, owner, group, mode)
        return True


def check_owner_group_mode(file, owner=None, group=None, mode=None):
    if owner == None:
        pass
    else:
        uid = pwd.getpwnam(owner).pw_uid
        os.chown(file, uid, -1)
    if group == None:
        pass
    else:
        gid = grp.getgrnam(group).gr_gid
        os.chown(file, -1, gid)
    if mode == 'None':
        pass
    else:
        os.chmod(file, int('0o{}'.format(mode), base=8))
    return True


if __name__ == '__main__':
    main()
