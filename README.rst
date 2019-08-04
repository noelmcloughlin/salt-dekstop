=============
salter
=============

Salt Desktop is a tool for building and deploying system environments without fuss.

If you are familar with yaml and want to inject dynamic profiles into your systems, this tool can help. The architectural design aims to keep users focused on profiles and associated configuration as much as possible.

*Profiles* are an minimilistic way of describing a wanted software environment; they can be dynamically created, shared, and reused in a predictable manner. *Configs* are an interface designed to hold global values distributble to hosts, and allowing us to alter default configuration with site/personal specifics. *Formulas/States* are pre-written salt states developed by open source communities.

Install
=======

```
curl -o salter.sh https://raw.githubusercontent.com/saltstack-formulas/salter/master/installer.sh && sudo bash salter.sh -i bootstrap && sudo bash salter.sh -i salt
```

Deploy profiles
===============

This command deploys a profile (pre-shipped or yours)-

```
sudo /usr/local/bin/salter.sh -i <profile-name> [ -u loginname ]
```

Upstream community repositories contain building blocks for profiles-

* `saltstack-formulas`_ (default)
* `salt-formulas`_
* `random salt-projects`_ (random example)

.. _`saltstack-formulas`: https://github.com/saltstack-formulas
.. _`salt-formulas`: https://github.com/salt-formulas
.. _`random salt-projects`: https://github.com/eligundry/salt.eligundry.com

Integration recommendation
==========================

Separate business logic artifacts from the consuming system. Store your salt artifacts in a separate git repository. You can integrate salter with your repo as follows (see `Reference Solution`_)-

1. Create following directories in your repository.

  * ``profiles/`` directory for your profiles; can be contributed upstream

  * ``configs/`` directory for your config or empty.

  * ``formulas/`` directory for your private formulas or empty.

  * ``scripts/overlay-salt.sh`` script like the working example in `./contrib/` directory.

2. Move your pillars/states to these new directories.

3. Overlay salter::

    curl -o scripts/overlay-salt.sh https://raw.githubusercontent.com/saltstack-formulas/salter/master/contrib/overlay-salt.sh
    sudo ./scripts/overlay-salt.sh

See `Reference Solution`_.

.. _`Reference-Solution`: https://github.com/noelmcloughlin/salter-overlay-demo

Notes
-----
The `overlay-salt.sh` script merges salter into your repository and integrates your artifacts into the initial install procedure. We have provided a working example in the `contrib/` directory.

salter is tested on python2 and python3 (default). This tool is reported to work on MacOS, FreeBSD, and most GNU/Linux. Salt states/fprrmulas are tested by the respective maintainers.
