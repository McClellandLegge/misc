#!/usr/bin/bash
set -x

cd /c/Users/msmck/Desktop/Git/Rpackages/

# produce the package manual
R CMD Rd2pdf --no-preview --output=csmtools/inst/csmtools.pdf --force --batch csmtools/

cd csmtools

# build the source package
R --slave <<< '.libPaths(c("C:/Users/msmck/Documents/R/win-library/3.3", "C:/Program Files/R/R-3.3.3/library")); devtools::build()'

cd ..

# move the source package to the cluster and install
pkg=$( ls csmtools*.tar.gz | sort | tail -1 )

echo $pkg
scp $pkg msmck@hdp0014:/mapr/mapr03r/analytic_users/msmck/usr/local/lib/build_site/

ssh msmck@hdp0014 "
cd /mapr/mapr03r/analytic_users/msmck/usr/local/lib/build_site/

R CMD INSTALL -l /mapr/mapr03r/analytic_users/msmck/usr/local/lib/R $pkg

find /mapr/mapr03r/analytic_users/msmck/usr/local/lib/R/csmtools/bin -type f -exec chmod a+x {} \;
"

