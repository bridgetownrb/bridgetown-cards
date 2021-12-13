# How to Contribute to Bridgetown Cards

It's very simple! First, you'll want to fork this repo. Then add a new file to the `src/_cards/2021`/`2022` folder using the following template:

https://github.com/bridgetownrb/bridgetown-cards/blob/main/src/_cards/_CARD_TEMPLATE.md

Commit that to a branch in your forked repo, then submit a Pull Request to this repo with your submission. We'll take a look, and if it makes the cut, we'll publish it!

**Note:** it's fine to link to other article(s) you've written, gems, repos, etc., but we ask that you make sure your submission itself contains the bulk of the information needed to demonstrate your working functionality.

----

# How to Install and Run Locally

## Table of Contents

- [Prerequisites](#prerequisites)
- [Install](#install)
- [Development](#development)
- [Commands](#commands)
- [Deployment](#deployment)
- [Contributing](#contributing)

## Prerequisites

- [GCC](https://gcc.gnu.org/install/)
- [Make](https://www.gnu.org/software/make/)
- [Ruby](https://www.ruby-lang.org/en/downloads/)
  - `>= 2.7`
- [Bridgetown Gem](https://rubygems.org/gems/bridgetown)
  - `gem install bridgetown -N`
- [Node](https://nodejs.org)
  - `>= 12`
- [Yarn](https://yarnpkg.com)

## Install

```sh
cd bridgetown-cards
bundle install && yarn install
```
> Learn more: [Bridgetown Getting Started Documentation](https://www.bridgetownrb.com/docs/).

## Development

To start your site in development mode, run `bin/bridgetown start` and navigate to [localhost:4000](https://localhost:4000/)!

### Commands

```sh
# running locally
bin/bridgetown start

# build & deploy to production
bin/bridgetown deploy

# load the site up within a Ruby console (IRB)
bin/bridgetown console
```

> Learn more: [Bridgetown CLI Documentation](https://www.bridgetownrb.com/docs/command-line-usage)

## Contributing

1. Fork it
2. Clone the fork using `git clone` to your local development machine.
3. Create your feature branch (`git checkout -b my-new-feature`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request