#!/usr/bin/python
import urllib.request as ur
from urllib.error import HTTPError


def tomcat_checksum(version):
    url = f"https://archive.apache.org/dist/tomcat/tomcat-{version.split('.')[0]}/v{version}/bin/apache-tomcat-{version}.tar.gz"
    try:
        checksum_url = url+'.sha512'
        webFile = ur.urlopen(checksum_url)
        checksum = webFile.read().decode('utf-8')
        return f"sha512:{checksum.split()[0]}"
    except HTTPError:
        checksum_url = url+'.md5'
        webFile = ur.urlopen(checksum_url)
        checksum = webFile.read().decode('utf-8')
        return f"md5:{checksum.split()[0]}"


class FilterModule(object):
    def filters(self):
        return {
            'tomcat_checksum': tomcat_checksum
        }
