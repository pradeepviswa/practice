#print("hi")
temperature = 75
forecast = "sunny"

if temperature > 80 or forecast == "rainy":
    print("Stay inside")
elif temperature < 80 and forecast !="rainy":
    print("Go Outside")
else:
    print("Go Outside")


rainy = True

if rainy:
    print("It's rainy outside. Stay inside")
elif not rainy:
    print("it is not rainy, go outside")
