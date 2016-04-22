#!/usr/bin/env bash

CERT_PATH=`pwd`/certs
PRIVATE_PATH=`pwd`/private

echo "---生成文件夹"
mkdir -p ${CERT_PATH}
mkdir -p ${PRIVATE_PATH}

echo "---生成随机数"
openssl rand \
-out ${PRIVATE_PATH}/.rand 1000

echo "---生成根证书私钥"
openssl genrsa \
-passout pass:\
-aes256 \
-rand ${PRIVATE_PATH}/.rand \
-out ${PRIVATE_PATH}/ca.key \
1024

echo "---生成证书签发申请文件"
openssl req \
-new \
-key ${PRIVATE_PATH}/ca.key \
-out ${PRIVATE_PATH}/ca.csr \
-subj "/C=CN/ST=GuangDong/L=ShenZhen/O=HuaWei/OU=PaaS/CN=ca"

echo "---自签发根证书"
openssl x509 \
-req \
-days 3650 \
-sha1 \
-extensions v3_ca \
-signkey ${PRIVATE_PATH}/ca.key \
-in ${PRIVATE_PATH}/ca.csr \
-out ${CERT_PATH}/ca.crt

echo "---生成服务端证书私钥"
openssl genrsa \
-passout pass:\
-aes256 \
-rand ${PRIVATE_PATH}/.rand \
-out ${PRIVATE_PATH}/server.key \
1024

echo "---生成证书签发申请文件"
openssl req \
-new \
-key ${PRIVATE_PATH}/server.key \
-out ${PRIVATE_PATH}/server.csr \
-subj "/C=CN/ST=GuangDong/L=ShenZhen/O=HuaWei/OU=PaaS/CN=server"

echo "---使用根证书签发服务端证书"
openssl x509 \
-req \
-days 3650 \
-sha1 \
-extensions v3_req \
-CA ${CERT_PATH}/ca.crt \
-CAkey ${PRIVATE_PATH}/ca.key \
-CAserial ${PRIVATE_PATH}/ca.srl \
-CAcreateserial \
-in ${PRIVATE_PATH}/server.csr \
-out ${CERT_PATH}/server.crt

echo "---生成客户端证书私钥"
openssl genrsa \
-passout pass:\
-aes256 \
-rand ${PRIVATE_PATH}/.rand \
-out ${PRIVATE_PATH}/client.key \
1024

echo "---生成证书签发申请文件"
openssl req \
-new \
-key ${PRIVATE_PATH}/client.key \
-out ${PRIVATE_PATH}/client.csr \
-subj "/C=CN/ST=GuangDong/L=ShenZhen/O=HuaWei/OU=PaaS/CN=client"

echo "---使用根证书签发客户端证书"
openssl x509 \
-req \
-days 3650 \
-sha1 \
-extensions v3_req \
-CA ${CERT_PATH}/ca.crt \
-CAkey ${PRIVATE_PATH}/ca.key \
-CAserial ${PRIVATE_PATH}/ca.srl \
-CAcreateserial \
-in ${PRIVATE_PATH}/client.csr \
-out ${CERT_PATH}/client.crt

echo "---生成节点证书私钥"
openssl genrsa \
-passout pass:\
-aes256 \
-rand ${PRIVATE_PATH}/.rand \
-out ${PRIVATE_PATH}/kubelet.key \
1024

echo "---生成证书签发申请文件"
openssl req \
-new \
-key ${PRIVATE_PATH}/kubelet.key \
-out ${PRIVATE_PATH}/kubelet.csr \
-subj "/C=CN/ST=GuangDong/L=ShenZhen/O=HuaWei/OU=PaaS/CN=kubelet"

echo "---使用根证书签发节点证书"
openssl x509 \
-req \
-days 3650 \
-sha1 \
-extensions v3_req \
-CA ${CERT_PATH}/ca.crt \
-CAkey ${PRIVATE_PATH}/ca.key \
-CAserial ${PRIVATE_PATH}/ca.srl \
-CAcreateserial \
-in ${PRIVATE_PATH}/kubelet.csr \
-out ${CERT_PATH}/kubelet.crt