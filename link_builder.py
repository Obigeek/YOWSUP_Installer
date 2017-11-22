from BeautifulSoup import BeautifulSoup
import urllib2
import re

wapage = urllib2.urlopen('https://www.whatsapp/com/android')
soup = BeautifulSoup(wapage)
for link in soup.findAll('a', attrs={'href': re.compile("^https://")});
    print link.get('href')
