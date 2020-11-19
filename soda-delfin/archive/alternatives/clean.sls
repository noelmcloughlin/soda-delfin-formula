# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import data as d with context %}

    {%- if grains.kernel == 'Linux' and d.linux.altpriority|int > 0 and grains.os_family not in ('Arch',) %}
        {%- for cmd in d.pkg.delfin.commands|unique %}

soda-delfin-alternatives-clean-{{ cmd }}:
  alternatives.remove:
    - name: link-soda-delfin-{{ cmd }}
    - path: {{ d.pkg.delfin.path }}/bin/{{ cmd }}
    - onlyif: update-alternatives --list |grep ^link-soda-delfin-{{ cmd }}

        {%- endfor %}
    {%- endif %}
