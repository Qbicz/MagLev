for f in `find *.pic`
do
  echo "Converting $f"
  sf=$(basename "$f")
  sf="${sf%.*}"
  dpic -g $f > ../pic_$sf.tex
done
