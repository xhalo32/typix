copyVirtualPaths() {
	:
	@copyAllVirtualPaths@
}

preBuildHooks+=(copyVirtualPaths)