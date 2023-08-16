      clear
      read -p "请输入Cloudflare的api：" api
      read -p "请输入Cloudflare注册时的邮箱：" email
      read -p "请输入你解析的域名：" yuming
      export CF_Key="$api"
      export CF_Email="$email"
      docker stop nginx
      curl https://get.acme.sh | sh
      ~/.acme.sh/acme.sh --register-account -m $email --issue -d $yuming --dns dns_cf --key-file /home/web/certs/${yuming}_key.pem --cert-file /home/web/certs/${yuming}_cert.pem --force
      docker start nginx