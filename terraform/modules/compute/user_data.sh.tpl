#!/bin/bash
set -xe

dnf update -y
dnf install -y docker amazon-cloudwatch-agent
systemctl enable --now docker

MONGO_URI=$(aws ssm get-parameter --name "${ssm_mongo_path}" --with-decryption --region ${region} --query 'Parameter.Value' --output text)

cat > /opt/aws/amazon-cloudwatch-agent/etc/config.json <<CWCONFIG
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/muchtodo/app.log",
            "log_group_name": "${log_group}",
            "log_stream_name": "{instance_id}"
          }
        ]
      }
    }
  }
}
CWCONFIG
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/etc/config.json

mkdir -p /var/log/muchtodo

docker pull ${backend_image}
docker run -d --restart unless-stopped \
  -p 8080:8080 \
  -e PORT=8080 \
  -e MONGO_URI="$MONGO_URI" \
  -e DB_NAME=much_todo_db \
  -e ENABLE_CACHE=true \
  -e REDIS_ADDR=${redis_endpoint}:6379 \
  -e LOG_LEVEL=INFO \
  -e LOG_FORMAT=json \
  --log-driver=json-file \
  -v /var/log/muchtodo:/var/log/muchtodo \
  ${backend_image}
