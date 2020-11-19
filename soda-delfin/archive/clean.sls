# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import data as d with context %}

    {%- if d.pkg.delfin.use_upstream == 'archive' and 'archive' in d.pkg.delfin %}
        {%- set sls_alternatives_clean = tplroot ~ '.archive.alternatives.clean' %}

include:
  - {{ sls_alternatives_clean }}

soda-delfin-archive-clean-managed-service:
  file.absent:
    - name: '{{ d.dir.delfin.service }}/{{ d.service.delfin.name }}.service'
  cmd.run:
    - name: systemctl daemon-reload
    - require:
      - file: soda-delfin-archive-clean-managed-service

soda-delfin-archive-absent:
  file.absent:
    - names:
      - {{ d.dir.delfin.tmp }}
      - {{ d.dir.delfin.log }}
      - {{ d.pkg.delfin.path }}
        {%- if d.linux.altpriority|int == 0 or grains.os_family in ('Arch', 'MacOS') %}
            {%- for cmd in d.pkg.delfin.commands|unique %}
      - /usr/local/bin/{{ cmd }}
            {%- endfor %}

        {%- endif %}
    {%- endif %}
