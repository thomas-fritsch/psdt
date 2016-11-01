
# Sets the version of the projects and child projects to a new version consistently.
# (Updates the version strings in all pom.xml, META-INF/MANIFEST.MF, feature.xml) 
#
# @see https://eclipse.org/tycho/sitedocs/tycho-release/tycho-versions-plugin/plugin-info.html
# @see https://eclipse.org/tycho/sitedocs/tycho-release/tycho-versions-plugin/set-version-mojo.html

if [ $# != 1 ]
then
  echo "Usage: $0 newVersion"
  exit 1
fi

mvn org.eclipse.tycho:tycho-versions-plugin:set-version -DnewVersion=$1
