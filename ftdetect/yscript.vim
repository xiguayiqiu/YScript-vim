<<<<<<< HEAD
" YScript file type detection
au BufNewFile,BufRead *.ys,*.yscript set filetype=yscript
au BufNewFile,BufRead *.ys,*.yscript set syntax=yscript
=======
au BufRead,BufNewFile *.ys,*.yscript setfiletype yscript
au BufRead,BufNewFile ysc.models,ysc.sum setfiletype yscmanifest
>>>>>>> c853ae8 (update vim 0.1.5.3)
