" YScript source and project manifest file type detection
au BufRead,BufNewFile *.ys,*.yscript setfiletype yscript
au BufRead,BufNewFile ysc.models,ysc.sum setfiletype yscmanifest
