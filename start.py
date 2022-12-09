import os
import pandas as pd
import json
import dat

df = pd.read_excel('input.xlsx')

with open('constants.json') as file:
    data = json.load(file)
    day_count = data["day_count"]
    worker_count = data["worker_count"]
    plot_count = data["plot_count"]
    initial_money = data["initial_money"]

    dat.add_single_param("day_count", day_count)
    dat.add_single_param("worker_count", worker_count)
    dat.add_single_param("plot_count", plot_count)
    dat.add_single_param("initial_money", initial_money)

dat.add_set("Crops", df["Crop"])

planting_times = []
for index, row in df[["Crop", "Plant"]].iterrows():
    planting_times.append({"name": row.Crop, "value": row.Plant})

growth_time = []
for index, row in df[["Crop", "Grow"]].iterrows():
    growth_time.append({"name": row.Crop, "value": row.Grow})

harvest_time = []
for index, row in df[["Crop", "Harvest"]].iterrows():
    harvest_time.append({"name": row.Crop, "value": row.Harvest})

purchase_price = []
for index, row in df[["Crop", "Buy"]].iterrows():
    purchase_price.append({"name": row.Crop, "value": row.Buy})

selling_price = []
for index, row in df[["Crop", "Sell"]].iterrows():
    selling_price.append({"name": row.Crop, "value": row.Sell})

dat.add_bidimension_param("planting_time", planting_times)
dat.add_bidimension_param("growth_time", growth_time)
dat.add_bidimension_param("harvest_time", harvest_time)
dat.add_bidimension_param("purchase_price", purchase_price)
dat.add_bidimension_param("selling_price", selling_price)

dat.generate()  

os.system('glpsol --cover --clique --gomory --mir -m "model.mod" -o "model.out"  -d "model.dat" -y display.txt')