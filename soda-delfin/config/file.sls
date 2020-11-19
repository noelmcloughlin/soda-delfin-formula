# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_archive_install = tplroot ~ '.archive.install' %}
{%- from tplroot ~ "/map.jinja" import data as d with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_archive_install }}

soda-delfin-config-file-file-managed:
  file.managed:
    - name: {{ d.dir.delfin.config }}{{ d.div }}{{ d.config.delfin.file }}
    - source: {{ files_switch(['config.jinja'],
                              lookup='soda-delfin-config-file-file-managed'
                 )
              }}
    - makedirs: True
    - template: jinja
    - require:
      - sls: {{ sls_archive_install }}
    - context:
        config: {{ d.config.delfin.content | json }}
        {%- if grains.os != 'Windows' %}
    - mode: 644
    - user: root
    - group: {{ d.identity.rootgroup }}
        {%- endif %}
