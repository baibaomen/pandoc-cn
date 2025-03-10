docker build -t baibaomen/pandoc-extra-cn:latest .

docker run --rm --volume "%CD%:/data" baibaomen/pandoc-extra-cn:latest test-chinese.md -o test-chinese.pdf --pdf-engine=xelatex -V CJKmainfont="Source Han Sans CN"