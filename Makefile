clean-docs:
	find docs -type f ! -name "CNAME" -delete
build:
	make clean-docs
	hugo
	git add docs/
