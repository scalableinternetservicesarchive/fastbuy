# -*- coding: utf-8 -*-
"""
Created on Fri Nov 20 17:06:42 2015

@author: Dongqiao Ma
"""

from bs4 import BeautifulSoup
from openpyxl import Workbook
from openpyxl.chart import BarChart, Reference

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
        if index >= 3:
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

# Anaylysis Sheet
sheet = wb.create_sheet('analysis', 0)
rows_name = ['Medium', 'Large', 'xLarge'];
# Response Time
sheet.append(['Response', 'Master', 'Cache'])
for index in range(len(folder_names) / 2):
    alist = []
    alist.append(rows_name[index])
    current_sheet = wb.get_sheet_by_name(folder_names[index])
    value = float(current_sheet['F5'].value.partition(' ')[0])
    alist.append(value)
    current_sheet = wb.get_sheet_by_name(folder_names[index + 3])
    value = float(current_sheet['F5'].value.partition(' ')[0])
    alist.append(value)   
    sheet.append(alist)
# 503
sheet.append(['503', 'Master', 'Cache'])
for index in range(len(folder_names) / 2):
    alist = []
    alist.append(rows_name[index])
    current_sheet = wb.get_sheet_by_name(folder_names[index])
    value = float(current_sheet['D29'].value.partition(' ')[0])
    alist.append(value)
    current_sheet = wb.get_sheet_by_name(folder_names[index + 3])
    value = float(current_sheet['D29'].value.partition(' ')[0])
    alist.append(value)   
    sheet.append(alist)
    
# Draw Response Chart
response_chart = BarChart()
response_chart.type = "col"
response_chart.style = 10
response_chart.title = "Response Time"

data = Reference(sheet, min_col=2, min_row=1, max_row=4, max_col=3)
cats = Reference(sheet, min_col=1, min_row=2, max_row=4)
response_chart.add_data(data, titles_from_data=True)
response_chart.set_categories(cats)
response_chart.shape = 4
sheet.add_chart(response_chart, "G1")

# Draw 503 Chart
response_chart = BarChart()
response_chart.type = "col"
response_chart.style = 10
response_chart.title = "503"

data = Reference(sheet, min_col=2, min_row=5, max_row=8, max_col=3)
cats = Reference(sheet, min_col=1, min_row=6, max_row=8)
response_chart.add_data(data, titles_from_data=True)
response_chart.set_categories(cats)
response_chart.shape = 4
sheet.add_chart(response_chart, "G16")

wb.save(dest_filename)
