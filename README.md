INFORMATON:

PACS - an alternative to paru/pacman -Ss.

I like paru fine, but I just wished it would split the packages into separate columns on my 4k monitor, and I also really wished it would put the description on the SAME LINE as the package name. I also thought the version number always being visible was kind of pointless, yes, I get it, it's the newest version. I just don't care, personally. 

The interactive installer(`-i) *runs the install commands with the flag --noconfirm*, I chose this over forcing yes to every quest on because typically it goes for the safer option. But if you have an issue with that find and replace all --noconfirm lines with nothing.


INSTALLATION:
```
cd ~
git clone https://github.com/harryeffinpotter/pacs
chmod +x ~/pacs/pacs.sh
```

Add this pacs function to ~/.zshrc for ez search.
E.G.: pacs zsh -s, pacs php -i, pacs haste
```
pacs(){
    # Wherever you clones the pacs repo to.
    # $0 = entire script path, $1 = first argument, $* = all arguments (does not include script path).
    ~/pacs/pacs.sh "$*"
}
```

Note:
--noconfirm is enabled with interactive package installer by default.



USAGE:

Syntax = ./pacs.sh <partial package name> <flags>
E.G.: ./pacs.sh zsh -s, ./pacs.sh php -i, ./pacs.sh haste
    
Flags:
`-h`: Show help.
`-s`: Simple output, no description, no version numbers.
`-i`: Interactive installer mode (highly recommeneded!)
