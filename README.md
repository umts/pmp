Ruby tools for generating UMass PMP documents from nice, safe, git-versioned
yaml.

Setup
=====

Create a git mirror
--------------------

You probably don't want to make a "fork" because, on GitHub, a fork of a
public repository can't be made private. Instead, you'll want to mirror a
copy:

First, create a new, private repository on GitHub. Next, mirror this code
to it:

```bash
git clone --bare https://github.com/umts/pmp.git tmp-pmp
cd tmp-pmp
git push --mirror <your repo address>
cd ..
rm -Rv tmp-pmp
git clone <your repo address>
```

Within your private copy, add the upstream as a remote (for updates):

```bash
git remote add upstream https://github.com/umts/pmp.git
```

Setup configuration
-------------------

The configuration `.yml` files are git-ignored in the public repository, but
you actually _do_ want to version them here in private.

```bash
cp .gitignore.example .gitignore
cp config.yml.example config.yml  #And edit to suit
cp goals.yml.example goals.yml  #And edit to suit
cp self-assessment.yml.example self-assessment.yml  #And edit to suit
git add .gitignore *.yml
git commit -m 'Initial configuration'
```

Use
===

There are just three Rake tasks:

* `rake 'begin_planning[yyyy]'` - outputs `out/planning-<yyyy>-<yyyy+1>.pdf`.
  n.b. that even though it's a planning worksheet, it doesn't exclude the
  review comments that exist in the file.
* `rake 'evaluate_planning[yyyy]'` - outputs
  `out/planning-<yyyy-1>-<yyyy>-evaluation.pdf`.
* `rake 'self_assessment[yyyy]'` - outputs `out/self-assessment-<yyyy>.pdf`.

Updating from upstream
======================

To keep your copy of the _software_ in this repository up-to-date, just merge
in using your `upstream` from above:

```bash
git fetch upstream
git merge upstream/master
```

Recommendations
==============

Use git tags to tag progress. There are, essentially, two meaningful points
per annual review period. Those are when the planning for the upcoming year is
finished, and when the review and self-assessment for the prior year are
complete.

Consider using GitHub pull-requests to demonstrate your proposed plan for next
year to your supervisor, and for your supervisor to leave their review comments.
