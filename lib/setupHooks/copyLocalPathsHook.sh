copyLocalPaths() {
	:
	@copyAllLocalPaths@
}

preBuildHooks+=(copyLocalPaths)
