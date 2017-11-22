from BeautifulSoup import BeautifulSoup
import urllib2
import re

html_page = urllib2.urlopen("https://www.whatsapp.com/android/")
soup = BeautifulSoup(html_page)
for link in soup.findAll('a', attrs={'href': re.compile("^https://")}):
    print link.get('href')
