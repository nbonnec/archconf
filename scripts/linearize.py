#!/usr/bin/env python3

import sys

N = 512

adc = []
lin_map = []

def linearize(adc_val):
    i = 0
    while i < len(lin_map) - 2:
        if adc_val == lin_map[i][1]:
            return lin_map[i][0]
        elif adc_val > lin_map[i + 1][1]:
            return lin_map[i][0] + ((adc_val - lin_map[i][1]) / (lin_map[i + 2][1] - lin_map[i][1]))
        i = i + 1


# get ADC value wanted
with open(sys.argv[1]) as f:
    data = f.read().splitlines()
    for line in data:
        adc.append(float(line))

with open(sys.argv[2]) as f:
    data = f.readlines()
    for line in data:
        lin_map.append(list(map(float, line.split())))


for i in adc:
    print(str(int(i)) + "  " + str(int(linearize(i) * 100)))
for i in adc:
    print('{: >6d}, /* {:>5d}  |  {:>5d}  |  xxxx  |  {: >6.2f}°C   */'
            .format(int(linearize(i) * 100.00),
                int(i),
                int(i // N),
                linearize(i)))

