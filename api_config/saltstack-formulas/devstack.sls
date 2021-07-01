# -*- coding: utf-8 -*-
# vim: ft=yaml
---
# SITE & RELEASE SPECIFIC DATA

  {%- set enabled_services = 'mysql,key' %}
  {%- set yoursvc_name = 'keystone' %}
  {%- set yoursvc_domain = 'default' %}
  {%- set yoursvc_version = 'v0.2.0' %}
  {%- set yoursvc_region = 'RegionOne' %}
  {%- set yoursvc_type = yoursvc_name ~ yoursvc_version %}
  {%- set yoursvc_endpoint = yoursvc_type %}
  {%- set yoursvc_endpath = yoursvc_name ~ '/' ~ yoursvc_version %}

  {%- set os_project_name = 'admin' %}
  {%- set os_password = 'devstack' %}
  {%- set host_ipv4 = grains.ipv4[-1] or '127.0.0.1' %}
  {%- set host_ipv6 = '' if not grains.ipv6 else grains.ipv6[-1] %}
  {%- set host = host_ipv4 or host_ipv6 %}
  {%- set port = '50040' %}

  {# mysql host must be 127.0.0.1 #}
  {# https://bugs.launchpad.net/devstack/+bug/1735097 #}
  {%- set db_host = '127.0.0.1' %}
  {# https://bugs.launchpad.net/devstack/+bug/1892531 #}

# DATA DICTIONARY

mysql:
  server:
    root_password: {{ os_password }}   # sync with devstack
    mysqld:
      bind_address: {{ db_host or host_ipv4 or "127.0.0.1" }}   # sync with devstack

devstack:
  lookup:
    master: template-master
    # Just for testing purposes
    winner: lookup
    added_in_lookup: lookup_value

  pkgs_purge:
    - python3-simplejson
  hide_output: true   # see stack.sh output?
  local:
    stack_user: stack
    os_password: {{ os_password }}
    os_project_name: {{ os_project_name }}
    admin_password: {{ os_password }}
    git_branch: 'stable/ussuri'
    enabled_services: {{ enabled_services }}
    host_ipv4: {{ host_ipv4 }}
    host_ipv6: {{ host_ipv6 }}
    service_host: {{ host_ipv4 or host_ipv6 }}
    db_host: {{ db_host }}
  managed:
    openrc: False

  dir:
    tmp: /tmp/devstack  {# not sure why centos wants this? #}

  ### openstack cli ###
  cli:

    # User
    user:
      create:
        {{ yoursvc_name }}:
          options:
            domain: {{ yoursvc_domain }}
            password: {{ os_password }}
            project: {{ os_project_name }}
            enable: True
      delete:
        demo:
          options:
            domain: default
        alt_demo:
          options:
            domain: default

    # Group
    group:
      create:
        service:
          options:
            domain: {{ yoursvc_domain }}
      add user:
        service:
          target:
            - {{ yoursvc_name }}
        admins:
          options:
            domain: {{ yoursvc_domain }}
          target:
            - {{ os_project_name }}

    # Role based authentication
    role:
      add:
        admin:
          options:
            project: {{ os_project_name }}
          user:
            - {{ yoursvc_name }}
        service:
          options:
            project: {{ os_project_name }}
          group:
            - service

    # Service
    service:
      create:
        {{ yoursvc_type }}:
          options:
            name: {{ yoursvc_name }}
            description: {{ yoursvc_name }} Service
            enable: True

    # Service Endpoint
    endpoint:
      create:
        {{ yoursvc_endpoint }} public https://{{ host }}/{{ port }}//{{ yoursvc_version }}/%\(tenant_id\)s:
          options:
            region: {{ yoursvc_region }}
            enable: True
        {{ yoursvc_endpoint }} internal https://{{ host }}/{{ port }}/{{ yoursvc_version }}/%\(tenant_id\)s:
          options:
            region: {{ yoursvc_region }}
            enable: True
        {{ yoursvc_endpoint }} admin https://{{ host }}/{{ port }}/{{ yoursvc_version }}/%\(tenant_id\)s:
          options:
            region: {{ yoursvc_region }}
            enable: True

    # Delete some presupplied stuff
    project:
      delete:
        demo:
          options:
            domain: default
        alt_demo:
          options:
            domain: default
        invisible_to_admin:
          options:
            domain: default


  tofs:
    # The files_switch key serves as a selector for alternative
    # directories under the formula files directory. See TOFS pattern
    # doc for more info.
    # Note: Any value not evaluated by `config.get` will be used literally.
    # This can be used to set custom paths, as many levels deep as required.
    files_switch:
      - any/path/can/be/used/here
      - id
      - roles
      - osfinger
      - os
      - os_family
    # All aspects of path/file resolution are customisable using the options below.
    # This is unnecessary in most cases; there are sensible defaults.
    # Default path: salt://< path_prefix >/< dirs.files >/< dirs.default >
    #         I.e.: salt://devstack/files/default
    # path_prefix: template_alt
    # dirs:
    #   files: files_alt
    #   default: default_alt
    # The entries under `source_files` are prepended to the default source files
    # given for the state
    # source_files:
    #   devstack-config-file-file-managed:
    #     - 'example_alt.tmpl'
    #     - 'example_alt.tmpl.jinja'

    # For testing purposes
    source_files:
      devstack-config-file-file-managed:
        - 'example.tmpl.jinja'
      devstack-subcomponent-config-file-file-managed:
        - 'subcomponent-example.tmpl.jinja'

  # Just for testing purposes
  winner: pillar
