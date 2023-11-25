PS C:\Users\萌萌哒\Desktop\key> keytool -genkey -v -keystore .\upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
输入密钥库口令:
再次输入新口令:
它们不匹配。请重试
输入密钥库口令:
再次输入新口令:
您的名字与姓氏是什么?
[Unknown]:  Huangrunheng
您的组织单位名称是什么?
[Unknown]:  OASX
您的组织名称是什么?
[Unknown]:  OASX
您所在的城市或区域名称是什么?
[Unknown]:  OASX
您所在的省/市/自治区名称是什么?
[Unknown]:  OASX
该单位的双字母国家/地区代码是什么?
[Unknown]:  OASX
CN=Huangrunheng, OU=OASX, O=OASX, L=OASX, ST=OASX, C=OASX是否正确?
[否]:  是

正在为以下对象生成 2,048 位RSA密钥对和自签名证书 (SHA256withRSA) (有效期为 10,000 天):
         CN=Huangrunheng, OU=OASX, O=OASX, L=OASX, ST=OASX, C=OASX
输入 <upload> 的密钥口令
        (如果和密钥库口令相同, 按回车):
[正在存储.\upload-keystore.jks]

Warning:
JKS 密钥库使用专用格式。建议使用 "keytool -importkeystore -srckeystore .\upload-keystore.jks -destkeystore .\upload-keystore.jks -deststoretype pkcs12" 迁移到行业标准格式 PKCS12。
PS C:\Users\萌萌哒\Desktop\key>





密码是 oasx-password