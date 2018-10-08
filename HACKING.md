# bootstrap

Install `docker`:

    yum install docker
    systemctl enable docker

Install `nginx`:

    yum install nginx
    rm /etc/nginx/nginx.conf
    ln -s /data/nginx/nginx.conf /etc/nginx/nginx.conf
    systemctl enable nginx

Install `docker-py`:

    easy_install pip
    pip install docker-py

Create deploy user

    useradd deploy -G docker
    passwd deploy
    visudo
    # add:
    #
    #  deploy ALL=NOPASSWD: /bin/systemctl start docker
    #  deploy ALL=NOPASSWD: /bin/systemctl stop docker
    #  deploy ALL=NOPASSWD: /bin/systemctl restart docker
    #  deploy ALL=NOPASSWD: /bin/systemctl start nginx
    #  deploy ALL=NOPASSWD: /bin/systemctl stop nginx
    #  deploy ALL=NOPASSWD: /bin/systemctl restart nginx
    #  deploy ALL=NOPASSWD: /usr/sbin/nginx

Bootstrap everything:

    cd system/ansible
    ansible-playbook ./boostrap.yml -i ./production --vault-password-file ~/.vault_pass.matteolandi.txt -vv¬
    ansible-playbook ./site.yml -i ./production --vault-password-file ~/.vault_pass.matteolandi.txt -vv¬

# build a module

Log into the remote docker registry:

    docker-machine start dev
    eval $(docker-machine env dev)
    docker login -u deploy -p $(keyring get docker.matteolandi.net deploy) matteolandi.net:5000

Build the module:

    mvn -T 1C -pl index clean deploy

Deploy the change:

    cd system/ansible
    ansible-playbook ./matteolandi-index.yml -i ./production --vault-password-file ~/.vault_pass.matteolandi.txt -vv