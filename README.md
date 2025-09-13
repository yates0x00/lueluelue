# README

an internal tool to present the penitration testing result


## setup (buntu)


### nmap wafw00f
apt install nmap wafw00f

### dirsearch
apt install python3

git clone https://github.com/maurosoria/dirsearch.git

### SecList
git clone https://github.com/danielmiessler/SecLists.git

### ehole
wget https://github.com/EdgeSecurityTeam/EHole/releases/download/v3.1/EHole_linux_amd64.zip && unzip  EHole_linux_amd64.zip

### theharvester

curl -LsSf https://astral.sh/uv/install.sh | sh

https://github.com/laramies/theHarvester

cd theHarvester

uv sync

uv run theHarvester ...

### nuclei

### wappalyzer

git clone https://github.com/dochne/wappalyzer.git official repo is down

直接用項目裏的吧

## usage

1.(optional)setup your VPN or proxy
2.setup PROXY environment.e.g.

```

# ~/env_my_proxy
export HTTP_PROXY="http://192.168.137.1:8080"
export HTTPS_PROXY="http://192.168.137.1:8080"
export http_proxy="http://192.168.137.1:8080"
export https_proxy="http://192.168.137.1:8080"
```

3.then run `source ~/env_my_proxy`, most of the commands you run in the following steps will use this proxy.

you should check the target manually to see if success, because some target will block your access because your IP is restricted. (e.g. from Russia, from China...)

4. rails server and open localhost:3000

5. run the delayed job command:

$ chmod +x bin/delayed_job

5.1 in development mode: $ bundle exec bin/delayed_job start
5.2 in production mode:  $ bundle exec bin/delayed_job start -n 2 -e production


6. add new target:

- create new project
- add batch of servers ( the root domain only )
- manually run the shuize script, and get all sub-domains
- add them to batch of servers
- trigger the scans ( see examples below )

6.1 bundle exec ruby scripts/detect_by_wafwoof.rb 32


## detections

should run these command manually or automatically:

- shuize
- theharvester
- dig
- wafw00f
- nmap
- wappalyzer
- ehole
- nuclei

- manually: run the dirsearch command

manually command: `$ bundle exec ruby scripts/detect_by_shuize.rb` (remember to change the code in this file )

TODO: make it automatic in future.

## installation

1.git clone https://github.com/yates0x00/lueluelue

2.install ruby 3.0.3

2.1 install asdf

2.2 install ruby requirements

2.3 $ asdf install ruby 3.0.3

2.4 gem install bundler

2.5 bundle install

3.import the SQL file to database ( e.g. MySQL 5.7 ) .

4.cp config/database.yml.example config/database.yml

5.rm config/credentials.yml.enc

6.EDITOR="vim" bundle exec rails credentials:edit

7.rails server

## env

Ruby 3.2.0

MySQL 5.7

