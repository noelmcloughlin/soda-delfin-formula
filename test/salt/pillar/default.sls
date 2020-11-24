# -*- coding: utf-8 -*-
# vim: ft=yaml
# format: soda-installer
---
soda-delfin:
  config:
    delfin:
      content:
        - [DEFAULT]
        - api_paste_config = /etc/delfin/api-paste.ini
        - delfin_cryptor = delfin.cryptor._Base64
        - api_max_limit = 1000
        - ''
        - [database]
        - connection = sqlite:////var/lib/delfin/delfin.sqlite
        - db_backend = sqlalchemy
        - ''
        - [scheduler]
        - config_path = /etc/delfin/scheduler_config.json
        - ''
        - [KAFKA]
        - kafka_topic_name = "delfin-kafka"
        - kafka_ip = 'localhost'
        - kafka_port = '9092'
  pkg:
    delfin:
      version: 1.0.0
      archive:
        source_hash: 8e1025683160340f41024bd1b47d2d6d619f3c41f16e590ec81eebaf04efd485
  linux:
    altpriority: 10000   # zero disables alternatives
