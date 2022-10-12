from msilib.schema import Error
from tkinter import ON
from turtle import goto
import time
from bs4 import BeautifulSoup
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.firefox.options import Options
import numpy as np
from random import randint
import pandas as pd
import requests
import csv
import os
import glob

files = glob.glob('C:/git/fao-wapor/data/*')
for f in files:
    os.remove(f)

options = Options()
options.set_preference("browser.download.folderList", 2)
options.set_preference("browser.download.manager.showWhenStarting", False)
options.set_preference("browser.download.dir", "C:\\git\\fao-wapor\\data")
options.set_preference("browser.helperApps.neverAsk.saveToDisk", "image/tiff")

options.binary_location = r'C:\Program Files\Mozilla Firefox\firefox.exe'
browser = webdriver.Firefox(options=options)

browser.maximize_window()  # For maximizing window
browser.implicitly_wait(30)  # gives an implicit wait for 30 seconds

browser.get(
    "https://wapor.apps.fao.org/catalog/WAPOR_2/1/L1_QUAL_NDVI_D")

browser.execute_script("document.body.style.zoom='50%'")
time.sleep(80)

file = open("sample.html","w")
file.write(browser.page_source)
file.close()

print("Stop")

# desc_data = browser.find_elements_by_class_name('content-details')
# here in your previous code this class('content-details') which is a single element so it is not iterable
# I used xpath to locate every every element <p> under the (id="content-details) attrid=bute

# loadMore = browser.find_elements(By.linkText,'Download')

# Currently needs manual sign in

def downloading_files():

    downloads = browser.find_elements(By.XPATH,"//span[contains(text(),'Download')]")

    for i in range(0,len(downloads)):

        element = downloads[i]

        element.click()

        download = browser.find_elements(By.PARTIAL_LINK_TEXT,"Click here")[0]

        download.click()

        time.sleep(10)

        browser.find_elements(By.XPATH,"//span[@class='fa fa-times ui-clickable ui-button-icon-left ng-star-inserted']")[0].click()

def flick_page():

    browser.find_elements(By.XPATH,"//span[@class='ui-paginator-icon pi pi-caret-right']")[0].click()

i = 1

while i < 100:

    downloading_files()
    flick_page()
    i = i+1









# if you you want to specify try this
#  para_detail = desc_data[0].text
#  expiry_ date = desc_data[1].text
