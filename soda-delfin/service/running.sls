# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_file = tplroot ~ '.config.file' %}
{%- from tplroot ~ "/map.jinja" import data as d with context %}

include:
  - {{ sls_config_file }}

soda-delfin-service-running-service-running:
  service.running:
    - name: {{ d.service.delfin.name }}
    - enable: True
    - watch:
      - sls: {{ sls_config_file }}
