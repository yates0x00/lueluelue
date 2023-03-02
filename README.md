# README

an internal tool to present the penitration testing result

## usage


1.(optional)setup your VPN or proxy
2.setup PROXY environment.e.g.

```
export HTTP_PROXY="http://192.168.137.1:8080"
export HTTPS_PROXY="http://192.168.137.1:8080"
export http_proxy="http://192.168.137.1:8080"
export https_proxy="http://192.168.137.1:8080"
```
3.manually query the target website, e.g. target.com, using shuize and theharvester

python3 ShuiZe.py -d nextcloud.com --proxy=socks5://192.168.31.224:1092


4.create server (in database) for "target.com", then

```
bundle exec ruby scripts/detect_by_theharvester.rb
```

5.create servers from shuize and theharvester result


```

```




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
