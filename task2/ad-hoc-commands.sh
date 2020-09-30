ansible webapp-server -i inventory.orig -b -u centos -m user -a "name=devops home=/home/devops"
ansible webapp-server -i inventory.orig -b -u centos -m copy -a "src=files/devops.sudoers dest=/etc/sudoers.d/devops"
ansible webapp-server -i inventory.orig -b -u centos -m authorized_key -a "user=devops key={{ lookup('file', 'files/devops.ssh.id-rsa.pub')}}"