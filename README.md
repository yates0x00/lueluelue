# README

an internal tool to present the penitration testing result

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

Ruby 3.0.3

MySQL 5.7
