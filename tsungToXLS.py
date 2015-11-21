# -*- coding: utf-8 -*-
"""
Created on Fri Nov 20 17:06:42 2015

@author: Dongqiao Ma
"""

from bs4 import BeautifulSoup
from openpyxl import Workbook

wb = Workbook()
source_folder = "F:/tsungtest/"
dest_filename = 'result.xlsx'
folder_names = ['master-medium','master-large','master-xlarge','cache-medium','cache-large','cache-xlarge']
for folder_name in folder_names:
    file_name = source_folder + folder_name + "/report.html"
    soup = BeautifulSoup(open(file_name))
    categories = soup.find_all("h3");
    tables = soup.find_all("table", class_="table")
    if folder_name == 'master-medium':
        sheet = wb.active
        sheet.title = folder_name
    else:
        sheet = wb.create_sheet(folder_name)

    for index in range(len(categories)):
        if index == 1:
            continue
        category = categories[index]
        if index > 2:
            table = tables[index + 1]
        else:
            table = tables[index]
            rows = table.find_all("tr")
        # Add Category Title
        sheet.append([category.text])
        # Add Table Headers
        titles = rows[0].find_all("th")
        alist = []
        for i in range(len(titles)):
            alist.append(" ".join(titles[i].text.split()))
        sheet.append(alist)
        # Add Table Rows
        for row in rows[1:]:
            cols = row.find_all("td")
            alist = []
            for col in cols:
                alist.append(col.text)
            sheet.append(alist)

wb.save(dest_filename)
