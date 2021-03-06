#!/bin/bash

if [[ $TRAVIS_BRANCH == 'master' ]]
then
  # Decrypt the deploy key
  openssl aes-256-cbc -K $encrypted_12aec5a48f60_key -iv $encrypted_12aec5a48f60_iv -in deploy_key.enc -out deploy_key -d

  # Start ssh agent and add key
  eval "$(ssh-agent -s)" # Start the ssh agent
  chmod 600 deploy_key
  ssh-add deploy_key

  # configure your name and email if you have not done so
  git config --global user.email "32667518+tamsinforbes@users.noreply.github.com"
  git config --global user.name "tamsinforbes"

  # clone the repository to the book-output directory
  git clone -b gh-pages \
    git@github.com:departmentfortransport/R-cookbook.git \
    book-output
  cd book-output
  git rm -rf *
  # Copy the new book and commit!
  cp -r ../_book/* ./
  git add --all *
  git commit -m "Travis built book"
  git push -q origin gh-pages
else
  echo "Not publishing as not in MASTER branch"
fi
