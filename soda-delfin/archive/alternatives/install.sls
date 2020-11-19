# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import data as d with context %}

    {%- if grains.kernel == 'Linux' and d.linux.altpriority|int > 0 and grains.os_family not in ('Arch',) %}
        {%- set sls_archive_install = tplroot ~ '.delfin.archive.install' %}

include:
  - {{ sls_archive_install }}

        {%- for cmd in d.pkg.delfin.commands|unique %}

soda-delfin-alternatives-install-bin-{{ cmd }}:
            {%- if grains.os_family not in ('Suse', 'Arch') %}
  alternatives.install:
    - name: link-soda-delfin-{{ cmd }}
    - link: /usr/local/bin/{{ cmd }}
    - order: 10
    - path: {{ d.pkg.delfin.path }}/{{ cmd }}
    - priority: {{ d.linux.altpriority }}
            {%- else %}
  cmd.run:
    - name: update-alternatives --install /usr/local/bin/{{ cmd }} link-soda-delfin-{{ cmd }} {{ d.pkg.delfin.path }}/{{ cmd }} {{ d.linux.altpriority }} # noqa 204
            {%- endif %}

    - onlyif:
      - test -f {{ d.pkg.delfin.path }}/{{ cmd }}
    - unless: update-alternatives --list |grep ^link-soda-delfin-{{ cmd }} || false
    - require:
      - sls: {{ sls_archive_install }}
    - require_in:
      - alternatives: soda-delfin-alternatives-set-bin-{{ cmd }}

soda-delfin-alternatives-set-bin-{{ cmd }}:
  alternatives.set:
    - unless: {{ grains.os_family in ('Suse', 'Arch') }} || false
    - name: link-soda-delfin-{{ cmd }}
    - path: {{ d.pkg.delfin.path }}/{{ cmd }}
    - onlyif: test -f {{ d.pkg.delfin.path }}/{{ cmd }}

        {%- endfor %}
    {%- endif %}
