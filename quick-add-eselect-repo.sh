#/bin/bash

### add via eselect repository / https://wiki.gentoo.org/wiki/Eselect/Repository
echo "/var/db/repos/genpi64 , the overlay will be added  to the new defalt location" 


emerge -bv dev-python/lxml app-eselect/eselect-repository && eselect repository add genpi64 git https://github.com/sakaki-/genpi64-overlay.git

echo "/var/db/repos/genpi64 , the ovelay should be ready to use.. " 
