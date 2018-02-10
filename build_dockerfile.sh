#!/bin/sh
# By Andrew Paradi | Source at https://github.com/andrewparadi/docker-uwaterloo

# Build PASS.apps, FAIL.apps: Ignore apps that fail to install
cat collections/ALL.apps | grep -E "adobereader-enu/|kbd/|console-setup|cpp-6/|cpp-7/|crystal/|fp-|fpc|g\+\+-6/|g\+\+-7/|gcc-6/|gcc-7|libgcc-6-dev/|libgcc-dev7/|glc|lgt|libasan3/|libasan4/|libelfhacks0/|libmpx2/|libpacketstream0/|libpython3.6-minimal/|libpython3.6-stdlib/|libstdc\+\+-6-dev/|libstdc\+\+-7-dev/|libxp6/|python3.6|sbt/|uptrack/|uwcs-|wine" > collections/FAIL.apps
cat collections/ALL.apps | grep -E -v "adobereader-enu/|kbd/|console-setup|cpp-6/|cpp-7/|crystal/|fp-|fpc|g\+\+-6/|g\+\+-7/|gcc-6/|gcc-7|libgcc-6-dev/|libgcc-7-dev/|glc|lgt|libasan3/|libasan4/|libelfhacks0/|libmpx2/|libpacketstream0/|libpython3.6-minimal/|libpython3.6-stdlib/|libstdc\+\+-6-dev/|libstdc\+\+-7-dev/|libxp6/|python3.6|sbt/|uptrack/|uwcs-|wine" > collections/PASS.apps

# Build INSTALL.apps, IGNORE.apps: Ignore GUI apps, latex, docs packages, locales, languages, only install lib files necessary
cat collections/PASS.apps | grep -E "abiword|account-|audio|chromium|compiz|cups|doc-|-doc|docbook|eclipse|epiphany|firefox|font|gnome|icon|indicator-|kde|kubuntu|latex|^tex|language|^lib|libreoffice|locale|media|netbeans|pdf|unity|theme|thunderbird|vlc|xfce4|xscreensaver|xserver|x11" > collections/IGNORE.apps
cat collections/PASS.apps | grep -E -v "abiword|account-|audio|chromium|compiz|cups|doc-|-doc|docbook|eclipse|epiphany|firefox|font|gnome|icon|indicator-|kde|kubuntu|latex|^tex|language|^lib|libreoffice|locale|media|netbeans|pdf|unity|theme|thunderbird|vlc|xfce4|xscreensaver|xserver|x11" > collections/INSTALL.apps

# Build per image IN.apps
for IMAGE in "thin" "full" "gcc"; do
	mkdir -p ./${IMAGE}
done
cp collections/PASS.apps full/IN.apps
cp collections/INSTALL.apps thin/IN.apps
cp collections/GCC.apps gcc/IN.apps

for IMAGE in "full" "thin" "gcc"; do

	# Init
	i=0
	opt="-y"
	rbs=3000 # RUN batch size: max is 3000, lower rbs produces more layers + easier to rebuild a layer if a package fails install
	Dockerfile="${IMAGE}/Dockerfile"
	apps="${IMAGE}/IN.apps"

	# Build Dockerfile
	echo "# By Andrew Paradi | Source at https://github.com/andrewparadi/docker-uwaterloo " > ${Dockerfile}
	echo "FROM ubuntu:16.04" >> ${Dockerfile}
	echo "LABEL Andrew Paradi <me@andrewparadi.com>" >> ${Dockerfile}
	echo "LABEL Tag: ${IMAGE}\n" >> ${Dockerfile}
	echo 'ARG\tDEBIAN_FRONTEND=noninteractive\n' >> ${Dockerfile}
	echo 'RUN\tapt-get update && \\' >> ${Dockerfile}
	echo '\tapt-get install apt-utils -y && \\' >> ${Dockerfile}

	for PACKAGE in $(cat ${apps} | cut -d "/" -f 1 | tail -n +2 )
	do
		((i++))
		(( i == 1 )) && echo "\tapt-get install ${PACKAGE} ${opt} && \\" >> ${Dockerfile}
		(( i % rbs == 1 )) && (( i != 1 )) && echo "RUN\tapt-get install ${PACKAGE} ${opt} && \\" >> ${Dockerfile}
		(( i % rbs != 1 )) && (( i % rbs != 0 )) && echo "\tapt-get install ${PACKAGE} ${opt} && \\" >> ${Dockerfile}
		(( i % rbs == 0 )) && echo "\tapt-get install ${PACKAGE} ${opt}" >> ${Dockerfile}
	done
	echo "\tapt-get clean && \\" >> ${Dockerfile}
	echo "\trm -rf /var/log" >> ${Dockerfile}

done