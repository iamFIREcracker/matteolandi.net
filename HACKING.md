# bootstrap

Install `docker`:

    $ yum install docker
    $ systemctl enable docker

Install `nginx`:

    $ yum install nginx
    $ rm /etc/nginx/nginx.conf
    $ ln -s /data/nginx/nginx.conf /etc/nginx/nginx.conf
    $ systemctl enable nginx

Install `docker-py`:

    $ easy_install pip
    $ pip install docker

Create deploy user

    $ useradd deploy -G docker
    $ passwd deploy
    $ visudo
    # add:
    #
    #  deploy ALL=NOPASSWD: /bin/systemctl start docker
    #  deploy ALL=NOPASSWD: /bin/systemctl stop docker
    #  deploy ALL=NOPASSWD: /bin/systemctl restart docker
    #  deploy ALL=NOPASSWD: /bin/systemctl start nginx
    #  deploy ALL=NOPASSWD: /bin/systemctl stop nginx
    #  deploy ALL=NOPASSWD: /bin/systemctl restart nginx
    #  deploy ALL=NOPASSWD: /usr/sbin/nginx
    #  deploy ALL=NOPASSWD: /usr/bin/cat /var/log/messages
    #  deploy ALL=NOPASSWD: /usr/bin/less /var/log/messages

Disable `requiretty` and `!visiblepw` settings from '/etc/sudoers' (like
explained here:
<https://unix.stackexchange.com/questions/49077/why-does-cron-silently-fail-to-run-sudo-stuff-in-my-script/49078#49078>)

Bootstrap everything:

    $ cd system/ansible
    $ venv/bin/ansible-playbook ./boostrap.yml -i ./production --vault-password-file ~/.vault_pass.matteolandi.txt -vv
    $ venv/bin/ansible-playbook ./site.yml -i ./production --vault-password-file ~/.vault_pass.matteolandi.txt -vv
    $ cd -

# build a module

Build the module:

    $ mvn -T 1C -pl index clean deploy

Deploy the change:

    $ cd system/ansible
    $ venv/bin/ansible-playbook ./matteolandi-index.yml -i ./production --vault-password-file ~/.vault_pass.matteolandi.txt -vv

Clean up, and go back home:

    $ cd -

# re-run a specific ansible role

Just do it:

    $ cd system/ansible
    $ venv/bin/ansible-playbook ./plan.yml -i ./production --vault-password-file ~/.vault_pass.matteolandi.txt -vv
    $ cd -

## virtualenv

In order for the previous command to work, you have to create a 'venv'
_virtualenv_ inside system/ansible first:

    $ cd system/ansible
    $ python3.8 -m virtualenv venv
    $ vpip install -r requirements.txt

### re-create the virtualenv

    $ cd system/ansible
    $ rm -rf venv
    $ python3.8 -m virtualenv venv
    $ vpip install ansible==2.9.10
    $ vpip freeze > requirements.txt
