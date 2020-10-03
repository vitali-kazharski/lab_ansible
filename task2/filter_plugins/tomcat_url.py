#!/usr/bin/python
def tomcat_url(version):
    url = f"https://archive.apache.org/dist/tomcat/tomcat-{version.split('.')[0]}/v{version}/bin/apache-tomcat-{version}.tar.gz"
    return url


class FilterModule(object):
    def filters(self):
        return {
            'tomcat_url': tomcat_url
        }
