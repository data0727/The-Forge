The Forge
========

The Forge is about building a community of decentralized professionals and apprentices alike, who can work together in an agile manner, on a variety of projects. It will provide the tools to track all the various bits of projects, user stories, tasks, resouce management, budget constraints, etc. , and provide for project funding, escrow, and developer payment.

We also want to provide an easy way to crowd fund ideas. That will definitely be built in.

Additionally, it's a game. Everyone has the chance to earn badges, level up, and earn new opportunities not available to the peons below you!

So download this, mod it, and start your own node. Or feel free to sign up with our (root service)[http://theforge.deepwoodsbrigade.com].

Eitherway, welcome to the community.

Update
------

When we first started this project we didn't have a name. Now that we do we've moved the repository to reflect that. The official git repository resides at: [http://github.com/thedeepwoodsbrigade/the-forge]

Please update your forks etc.

Requirements
============

- Ruby 1.9.2
- Bundler
- MongoDB

Installation
============

Most of the core developers use Lion and deploy to Heroku. Though one of the near future plans is to make communal node decentralized. So, we are seeking developers from other platforms to add to this. If you are one of those other developers cheers!

Mac OS X Lion
-------------

If you are using RVM we have a .rvmrc file that will automatically create a gemset for you.

If you don't have Ruby 1.9.2 installed:

    rvm install 1.9.2

Install MongoDB (using ['Homebrew']('http://mxcl.github.com/homebrew/'))

    brew install mongodb

Follow the onscreen instructions, then download the project:

    git clone git@github.com:rebelhold/communal.git

And accept the gemset creation:

    cd communal

Finally Bundle!

    gem install bundler --no-ri --no-rdoc
    bundle install

