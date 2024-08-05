# get details of loan
money_owed = float(input('How much money do you owe, in dollars?\n')) # 50000
apr = float(input('what is the annual percent rate of the loan?\n')) # 3%
payment = float(input('How much will you pay off each month in dolars?\n')) #1000
months = int(input('how many months do you want to see the results for?\n')) #24

monthly_rate = apr/100/12

for i in range(months):

    # calculate interest to pay
    interest_paid = money_owed * monthly_rate

    # add in interest
    money_owed = money_owed + interest_paid

    if (money_owed - payment) < 0:
        print('The last payemnt is', money_owed)
        print('You paid off load in', i+1, 'months')
        break
        

    # make payment
    money_owed = money_owed - payment

    print('Paid', payment ,'of which', interest_paid ,'was interest', end = ' ')
    print('Now I owe', money_owed)

