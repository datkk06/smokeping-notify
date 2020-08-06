# Cài đặt trên CentOS 7

## Cài đặt gói cpan 

```sh
yum install perl-CPAN
```

## Cài đặt các gói phụ trợ

```sh
cpan install Slack::Notify
```

## Tạo mới file cấu hình cảnh báo và ghi log

```sh
touch /var/log/smokeping
touch /etc/smokeping/notify
```

## Clone repo đã custom cảnh báo

```sh
git clone https://github.com/datkk06/smokeping-notify.git
```

## Backup lại source cũ và thay thế  bằng source custom đã clone về

```sh
mv /usr/share/smokeping /usr/share/smokeping_bak
cp -R smokeping-notify/ /usr/share/smokeping
```

## Mở file cấu hình cảnh báo

```sh
vi /etc/smokeping/notify
```

## Thêm các cấu hình cảnh báo về telegram và slack

```sh
# Telegram token and chat_id
telegram_token = token-telegram
telegram_chat_id = chat-id-telegram

# Slack hook URL
slack_hook_url = https://hooks.slack.com/services/example
```

## Mở file cấu hình smokeping

```sh
vi /etc/smokeping/config
```

## Tại đây thêm cấu hình như bên dưới

```sh
to = example@gmail.com
```

>>> Lưu ý rằng: Dù chỉ dùng cảnh báo qua telegram và slack nhưng vẫn phải thêm cấu hình trên

## Khởi động lại dịch vụ

```sh
systemctl restart httpd
systemctl restart smokeping
```

## Kiểm tra lại file log tại

```
cat /var/log/smokeping
```
