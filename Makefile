clean-docs:
	find docs -type f ! -name "CNAME" -delete
publish:
	make clean-docs
	hugo
	git add docs/
	git commit -m "Gen site to docs"
