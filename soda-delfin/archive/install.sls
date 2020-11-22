# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import data as d with context %}

    {%- if d.pkg.delfin.use_upstream == 'archive' and 'archive' in d.pkg.delfin %}
        {%- from tplroot ~ "/files/macros.jinja" import format_kwargs with context %}
        {%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

soda-delfin-archive-install-deps:
        {%- if 'deps' in d.pkg.delfin and d.pkg.delfin.deps %}
  pkg.installed:
    - names: {{ d.pkg.delfin.deps|json }}
    - reload_modules: true
    - require_in:
      - file: soda-delfin-archive-install
        {%- endif %}

soda-delfin-archive-install:
        {%- if 'conflicts' in d.pkg.delfin and d.pkg.delfin.conflicts %}
  pkg.purged:
    - names: {{ d.pkg.delfin.conflicts|json }}
    - reload_modules: true
    - require_in:
      - file: soda-delfin-archive-install
        {%- endif %}
        {%- if 'pips' in d.pkg.delfin and d.pkg.delfin.pips %}
  pip.installed:
    - names: {{ d.pkg.delfin.pips|json }}
    - upgrade: True
    - reload_modules: true
    - require_in:
      - file: soda-delfin-archive-install
        {%- endif %}
  file.directory:
    - name: {{ d.pkg.delfin.path }}
    - makedirs: True
    - clean: true
    - require_in:
      - archive: soda-delfin-archive-install
        {%- if grains.os != 'Windows' %}
    - mode: 755
    - user: {{ d.identity.rootuser }}
    - group: {{ d.identity.rootgroup }}
    - recurse:
        - user
        - group
        - mode
        {%- endif %}
  archive.extracted:
    - unless: test -x {{ d.pkg.delfin.path }}{{ d.div }}/script/start.sh
    {{- format_kwargs(d.pkg.delfin.archive) }}
    - retry: {{ d.retry_option|json }}
    - enforce_toplevel: false
    - trim_output: true
    - require:
      - file: soda-delfin-archive-install
        {%- if grains.os != 'Windows' %}
    - user: {{ d.identity.rootuser }}
    - group: {{ d.identity.rootgroup }}
    - recurse:
        - user
        - group
        {%- endif %}
        {%- if 'service' in d and 'delfin' in d.service and d.service.delfin is mapping %}

soda-delfin-archive-install-file-directory:
  file.directory:
    - names:
      - {{ d.dir.delfin.lib }}
      - {{ d.dir.delfin.log }}
    - makedirs: True
            {%- if grains.os != 'Windows' %}
    - user: {{ d.identity.rootuser }}
    - group: {{ d.identity.rootgroup }}
    - mode: '0755'
            {%- endif %}
            {%- if grains.kernel|lower == 'linux' %}

soda-delfin-archive-install-managed-service:
  file.managed:
    - name: '{{ d.dir.delfin.service }}/{{ d.service.delfin.name }}.service'
    - source: {{ files_switch(['systemd.ini.jinja'],
                              lookup='soda-delfin-archive-install-managed-service'
                 )
              }}
    - mode: '0644'
    - user: {{ d.identity.rootuser }}
    - group: {{ d.identity.rootgroup }}
    - makedirs: True
    - template: jinja
    - context:
        desc: {{ d.service.delfin.name }} service
        doc: https://github.com/sodafoundation/delfin
        name: {{ d.service.delfin.name }}
        user: {{ d.identity.rootuser }}
        group: {{ d.identity.rootgroup }}
        workdir: {{ d.pkg.delfin.path }}
        start: {{ d.pkg.delfin.path }}/{{ d.service.delfin.start }}
        stop: {{ d.pkg.delfin.path }}/{{ d.service.delfin.start }}
  cmd.run:
    - name: systemctl daemon-reload
    - require:
      - archive: soda-delfin-archive-install

            {%- endif %}
        {%- endif %}

soda-delfin-archive-install-prometheus-exporter-file:
  file.managed:
    - name: {{ d.dir.delfin.lib }}{{ d.div }}delfin_exporter.txt
    - makedirs: True

soda-delfin-archive-install-api-paste:
  file.managed:
    - name: {{ d.dir.delfin.config }}/api-paste.ini
    - source: {{ d.pkg.delfin.path }}/etc/delfin/api-paste.ini
    - makedirs: True

soda-delfin-archive-install-delfin.conf:
  file.managed:
    - name: {{ d.dir.delfin.config }}/delfin.conf.devs
    - source: {{ d.pkg.delfin.path }}/etc/delfin/delfin.conf
    - makedirs: True

soda-delfin-archive-install-scheduler_config:
  file.managed:
    - name: {{ d.dir.delfin.config }}/scheduler_config.json
    - source: {{ d.pkg.delfin.path }}/etc/scheduler_config.json
    - makedirs: True

    {%- else %}

soda-delfin-archive-install-other:
  test.show_notification:
    - text: |
        The soda-delfin archive is unavailable/unselected for {{ salt['grains.get']('finger', grains.os_family) }}

    {%- endif %}
