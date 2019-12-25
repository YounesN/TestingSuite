import numpy as np
import csv

master_s = []
master = []
dev_s = []
dev = []
with open('master.log', 'r') as masterFile:
    dialect = csv.Sniffer().sniff(masterFile.read(1024), delimiters=' ,')
    masterFile.seek(0)
    csvReader = csv.reader(masterFile, dialect)
    for row in csvReader:
        master_s.append(int(row[0]))
        master.append(float(row[1]))

with open('dev.log', 'r') as devFile:
    dialect = csv.Sniffer().sniff(devFile.read(1024), delimiters=' ,')
    devFile.seek(0)
    csvReader = csv.reader(devFile, dialect)
    for row in csvReader:
        dev_s.append(int(row[0]))
        dev.append(float(row[1]))

with open('out.log', 'w') as outFile:
    for i in range(len(master)):
        outFile.write('{},{}\n'.format(master_s[i], master[i]-dev[i]))
