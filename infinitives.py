import sys
import re
import time
import io
import urllib2
import os.path
from gtts import gTTS
from googletrans import Translator

def makemp3s():

  f = io.open('verbs.html', mode='r', encoding="utf-8")
  #p = re.compile('^(.*?) , <a href=https://www\.italian-verbs\.com/italian-verbs/conjugation.php\?verbo=.*?>(.*?)</a> , <a href=http://conjugator.reverso.net/conjugation-french-verb-(.*?).html>(.*?)</a> , <a href=http://www.verbix.com/webverbix/German/(.*?).html>(.*?)</a> , (.*?)<br/>')
  p = re.compile('^(.*?) , <a href=https://www\.italian-verbs\.com/italian-verbs/conjugation.php\?verbo=.*?>(.*?)</a>')

  i = 0
  for line in f.readlines():
  	i += 1
  	match = p.match(line)
  	path = 'c:\\1\\slow\\' + match.group(2) + '.mp3'
 	if not os.path.exists(path):
 	  	tts = gTTS(text=match.group(2), lang='it', slow=True)
 	  	tts.save(path)
 	  	time.sleep(1)
  	#tts = gTTS(text=match.group(2), lang='it', slow=False)
  	#tts.save('c:\\1\\normal\\' + match.group(2) + '.mp3')


def fixgerman():

	f = io.open('c:\\1\\helloworld.html',mode='w', encoding="utf-8")
	v = io.open('c:\\1\\verbs.html',mode='r', encoding="utf-8")

	#for line in enumerate(v):


def getitalian():

    f = io.open('c:\\1\\helloworld.html',mode='w', encoding="utf-8")
    p = re.compile('(\/italian-verbs\/conjugation\.php\?verbo=.*?)">(.*?)<')

    for i in range(1, 357):
        verbsUrl = "https://www.italian-verbs.com/italian-verbs/italian-verbs-top.php?pg=" + str(i)
        response = urllib2.urlopen(verbsUrl)
        html = response.read()

        results = p.finditer(html)
        t = Translator()

        for m in results:
            v = m.group(2)
            t_fr=t.translate(v, dest="fr", src="it")
            t_en=t.translate(v, dest="en", src="it")
            t_ru=t.translate(v, dest="ru", src="it")
            t_de=t.translate(v, dest="de", src="it")
            f.write(t_en.text +
                  " , " +
                  "<a href=https://www.italian-verbs.com"+m.group(1)+">"+v+"</a>"+
                  " , "+
                  "<a href=http://conjugator.reverso.net/conjugation-french-verb-"+t_fr.text+".html>"+t_fr.text+"</a>"+
                  " , "+
                  "<a href=http://www.verbix.com/webverbix/German/" + t_de.text + ".html>" + t_de.text + "</a>"+
                  " , "+
                  t_ru.text + "<br/>")

def main():
    #getitalian()
    #fixgerman()
    makemp3s()

if __name__ == "__main__":
    sys.exit(main())