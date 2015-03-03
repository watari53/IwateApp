# -*- coding: utf-8 -*-

import re

from urllib import urlopen
from HTMLParser import HTMLParser
import urllib2
from BeautifulSoup import BeautifulSoup
import csv
import sys

def main():
  for page_number in range(1,9):
    getPage(page_number)

def getPage(page_number):
  jaran_site = "http://www.jalan.net/kankou/400000/400100/" #横浜市スポット情報サイトのURL
  jaran_site = jaran_site+"page_"+str(page_number)+"/?screenId=OUW1324"
  print "---page---"
  print jaran_site
  opener = urllib2.build_opener()
  html = opener.open(jaran_site)
  soup = BeautifulSoup(html)
  spots =  soup.findAll("p",{"class":"item-name rank-ico-0x"})
  for spot in spots:
    spot_detail_url = spot.findAll("a")[0].get("href")
    getSpotDetailPage(spot_detail_url)

def getSpotDetailPage(detail_url):
  opener = urllib2.build_opener()
  html = opener.open(detail_url)
  soup = BeautifulSoup(html,fromEncoding='Shift_JIS')
  spot_title =  soup.findAll("h1",{"class":"detailTitle"})[0].text
  spot_address = soup.findAll("td",{"id":"detailMap"})[0].text.split("MAP")[0]
  print spot_title
  print spot_address
  csvFile = open('FukuokaSpotsList_tmp.csv', 'ab') #ファイルが無ければ作る、の'a'を指定します
  csvWriter = csv.writer(csvFile)
  csvData = []
  csvData.append(spot_title)
  csvData.append(spot_address)
  csvWriter.writerow(csvData)
  csvFile.close()

if __name__ == '__main__':
  main()
