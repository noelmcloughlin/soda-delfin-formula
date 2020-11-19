# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import data as d with context %}

soda-delfin-service-clean-service-dead:
  service.dead:
    - name: {{ d.service.delfin.name }}
    - enable: False
