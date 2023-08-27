INSTALLATION:

Requirements - yay, 
`cd ~`
`git clone https://github.com/harryeffinpotter/pacs`
`chmod +x ~/pacs/pacs.sh`

Add this to pacs function below to ~/.zshrc for ez search.
E.G.: pacs zsh -s, pacs php -i, pacs haste
```pacs(){
    # Wherever you clones the pacs repo to.
    # $0 = entire script path, $1 = first argument, $* = all arguments (does not include script path).
    ~/pacs/pacs.sh "$*"
}```

Note:
--noconfirm is enabled with interactive package installer by default.



USAGE:

Syntax = ./pacs.sh <partial package name> <flags>
E.G.: ./pacs.sh zsh -s, ./pacs.sh php -i, ./pacs.sh haste
    
Flags:
`-h`: Show help.
`-s`: Simple output, no description, no version numbers.
`-i`: Interactive installer mode (highly recommeneded!)
