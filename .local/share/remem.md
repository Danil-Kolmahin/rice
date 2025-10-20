# search for comunity cheatsheets
curl cheat.sh

# clear clipboard history
cliphist wipe

# clear duplicates from command-line history
# TODO

# convert curl to hurl
echo "curl google.com" | hurlfmt --in curl

# pass: gpg key generation
gpg --gen-key
# Real name:
# Email address:
# Change (N)ame, (E)mail, or (O)kay/(Q)uit?
# We need to generate a lot of random bytes. It is a good idea to perform
# some other action (type on the keyboard, move the mouse, utilize the
# disks) during the prime generation; this gives the random number
# generator a better chance to gain enough entropy.
# gpg: revocation certificate stored as '/home/$HOME/.gnupg/openpgp-revocs.d/$ID.rev'
gpg --edit-key $ID
> expire
# Key is valid for? (0)
# Is this correct? (y/N)
> save

# pass
pass init $ID
# mkdir: created directory '/home/$HOME/.password-store/'
# git config --global init.defaultBranch main
pass git init
(cd /home/$HOME/.password-store/ && git config user.email "you@example.com")
(cd /home/$HOME/.password-store/ && git config user.name "Your Name")
pass git init

# get all upper level node_modules
find . -type d -name node_modules -prune

# archiving with tar and gzip
tar -I 'gzip -9' -cf backup.tar.gz etc
# archiving with tar only
tar -cf backup.tar.gz etc
# extract any tar archive (result would be etc directory)
tar -xf backup.tar.gz
# view archive content (without changes, like ls -la)
tar -tvf backup.tar.gz
