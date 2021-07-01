lxd:
  lookup:
    python:
      packages:
        - python3-pip
  containers:
    local:
      bootstraptest:
        opts:
          require:
          - {lxd_profile: lxd_profile_local_default}
          - {lxd_profile: lxd_profile_local_autostart}
          - {lxd_image: lxd_image_local_ubuntu_xenial_amd64}
        profiles: [default, autostart]
        running: true
        source: xenial/amd64
        bootstrap_scripts:
          - cmd: [ '/bin/sleep', '2' ]

          - src: salt://lxd/scripts/bootstrap.sh
            dst: /root/bootstrap.sh
            cmd: [ '/root/bootstrap.sh', 'bootstraptest', 'pcdummy.lan', 'salt.pcdummy.lan', 'true' ]

          - cmd: [ '/usr/bin/salt-call', 'state.apply' ]

  images:
    local:
      ubuntu_xenial_amd64:
        name: ubuntu/xenial/amd64
        aliases:
          - xenial/amd64
          - ubuntu/xenial/amd64
        auto_update: true
        public: false
        source:
          name: ubuntu/xenial/amd64
          remote: images_linuxcontainers_org
  lxd:
    init: {network_address: '[::]', network_port: 8443, trust_password: PassW0rd}
    run_init: true
  profiles:
    local:
      autostart:
        config:
          boot.autostart: 1
          boot.autostart.delay: 2
          boot.autostart.priority: 1
      default:
        devices:
          eth0:
            nictype: macvlan
            parent: eth1
            type: nic
