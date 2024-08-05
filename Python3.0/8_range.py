r = range(7)
print(r)
range(0,7,1)

expense = []
numberOfExpenses = int(input("Number of Expense : "))

for i in range(numberOfExpenses):
    expense.append(float(input("Enter Expense : ")))

total = sum(expense)

print('Total expense is $', total, sep='')
